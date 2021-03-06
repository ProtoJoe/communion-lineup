# Amount should be a decimal between 0 and 1. Lower means darker
def darken_color(hex_color, amount=0.8)
  rgb = hex_color.scan(/../).map {|color| color.hex}
  rgb[0] = (rgb[0].to_i * amount).round
  rgb[1] = (rgb[1].to_i * amount).round
  rgb[2] = (rgb[2].to_i * amount).round
  "%02x%02x%02x" % rgb
end

# Amount should be a decimal between 0 and 1. Higher means lighter
def lighten_color(hex_color, amount=0.8)
  rgb = hex_color.scan(/../).map {|color| color.hex}
  rgb[0] = [(rgb[0].to_i + 255 * amount).round, 255].min
  rgb[1] = [(rgb[1].to_i + 255 * amount).round, 255].min
  rgb[2] = [(rgb[2].to_i + 255 * amount).round, 255].min
  "%02x%02x%02x" % rgb
end

class CommunionPdf < Prawn::Document
  WHITE               = 'FFFFFF'
  BLACK               = '000000'
  RED                 = 'FF0000'
  CHOIR_LIGHT         = 'bbb185'
  CHOIR_DARK          = darken_color(CHOIR_LIGHT)
  LEFT_WING_LIGHT     = '7ca4dc'
  LEFT_WING_DARK      = darken_color(LEFT_WING_LIGHT, 0.6)
  RIGHT_WING_LIGHT    = 'a48fbb'
  RIGHT_WING_DARK     = darken_color(RIGHT_WING_LIGHT, 0.6)
  FRONT_LEFT_LIGHT    = 'fd646d'
  FRONT_LEFT_DARK     = darken_color(FRONT_LEFT_LIGHT)
  FRONT_MID_LIGHT     = '82c93f'
  FRONT_MID_DARK      = darken_color(FRONT_MID_LIGHT, 0.6)
  FRONT_RIGHT_LIGHT   = 'A14748'
  FRONT_RIGHT_DARK    = darken_color(FRONT_RIGHT_LIGHT, 0.6)
  BACK_MID_LIGHT      = 'fec30a'
  BACK_MID_DARK       = darken_color(BACK_MID_LIGHT)
  LEFT_BALCONY_LIGHT  = '959595'
  LEFT_BALCONY_DARK   = darken_color(LEFT_BALCONY_LIGHT)
  RIGHT_BALCONY_LIGHT = '83c2d5'
  RIGHT_BALCONY_DARK  = darken_color(RIGHT_BALCONY_LIGHT, 0.4)
  NURSERY             = '00FFB8'

  def initialize(lineup)
    super(page_layout: :landscape)

    # Basic font options.
    font 'Helvetica', style: :normal

    # Header text.
    y_position = cursor + 18
    text_box "Smoke Rise Baptist Church Sanctuary",
              height: 50,
              overflow: :truncate,
              at: [0, y_position],
              align: :center,
              size: 14

    # Draw the background.
    draw_choir
    draw_lower_level
    draw_balcony
    draw_labels
    draw_seating(lineup)

    # Now populate the positions.
    fill_names(lineup)

    # Label the document.
    draw_date(lineup)

    # Time for the Seating Chart
    start_new_page(margin: [0, 40])

    # Page Heading
    fill_color BLACK
    y_position = cursor - 18
    text_box "Seating Chart",
              height: 50,
              overflow: :truncate,
              at: [0, y_position],
              align: :center,
              style: :bold_italic,
              size: 14

    pad(20) do
      draw_paths(lineup)
      draw_entrance_lineup(lineup)
    end
    draw_balcony_lineup(lineup)
  end

  private

  def draw_balcony_lineup(lineup)
    draw_position_circle(240, 70, "14", LEFT_BALCONY_DARK)
    text_box  lineup.position_14,
              at: [0, 70],
              width: 210,
              align: :right,
              style: :bold,
              size: 12
    draw_position_circle(240, 30, "16", LEFT_BALCONY_LIGHT)
    text_box  lineup.position_16,
              at: [0, 30],
              width: 210,
              align: :right,
              style: :bold,
              size: 12

    draw_position_circle(480, 70, "13", RIGHT_BALCONY_DARK)
    text_box  lineup.position_13,
              at: [510, 70],
              align: :left,
              style: :bold,
              size: 12
    draw_position_circle(480, 30, "15", RIGHT_BALCONY_LIGHT)
    text_box  lineup.position_15,
              at: [510, 30],
              align: :left,
              style: :bold,
              size: 12

    fill_color RED
    text_box  "Balcony",
              at: [0, 90],
              align: :center,
              style: :bold_italic,
              size: 12

    draw_line([360, 70], [280, 70], RED, 2, nil, :left_arrow, :dot)
    draw_line([360, 70], [280, 30], RED, 2, nil, :left_arrow, :dot)
    draw_line([360, 70], [440, 70], RED, 2, nil, :right_arrow, :dot)
    draw_line([360, 70], [440, 30], RED, 2, nil, :right_arrow, :dot)
    end

  def draw_entrance_lineup(lineup)
    yStart = 440
    # Left side
    fill_color RED
    text_box  "Left Center Aisle Door",
              at: [0, yStart],
              width: 240,
              align: :right,
              style: :bold,
              size: 12
    draw_line([140, yStart - 15], [280, yStart - 15], RED, 3, nil, :right_arrow)
    text_box  "Turn Right at the Front Row",
              at: [0, yStart - 20],
              width: 280,
              align: :right,
              style: :bold_italic,
              size: 11
    draw_line([280, yStart - 160], [140, yStart - 160], RED, 3, nil, :left_arrow)
    text_box  "Turn Left at the Front Row",
              at: [0, yStart - 165],
              width: 280,
              align: :right,
              style: :bold_italic,
              size: 11
              
    draw_position_circle(270, yStart - 55, "2", FRONT_MID_LIGHT)
    text_box  lineup.position_2,
              at: [0, yStart - 55],
              width: 240,
              align: :right,
              style: :bold,
              size: 12
    draw_position_circle(270, yStart - 95, "4", FRONT_LEFT_DARK)
    text_box  lineup.position_4,
              at: [0, yStart - 95],
              width: 240,
              align: :right,
              style: :bold,
              size: 12
    draw_position_circle(270, yStart - 135, "6", FRONT_LEFT_LIGHT)
    text_box  lineup.position_6,
              at: [0, yStart - 135],
              width: 240,
              align: :right,
              style: :bold,
              size: 12
    draw_position_circle(270, yStart - 195, "12", LEFT_WING_DARK)
    text_box  lineup.position_12,
              at: [0, yStart - 195],
              width: 240,
              align: :right,
              style: :bold,
              size: 12
    draw_position_circle(270, yStart - 235, "10", LEFT_WING_LIGHT)
    text_box  lineup.position_10,
              at: [0, yStart - 235],
              width: 240,
              align: :right,
              style: :bold,
              size: 12
    draw_position_circle(270, yStart - 275, "8", BACK_MID_LIGHT)
    text_box  lineup.position_8,
              at: [0, yStart - 275],
              width: 240,
              align: :right,
              style: :bold,
              size: 12

    # Middle
    draw_line([346, yStart - 275], [346, yStart - 35], RED, 3, nil, :up_arrow)
    fill_color BLACK
    text_box  "ENTRANCE",
              at: [358, yStart - 45],
              width: 9,
              height: 250,
              align: :center,
              style: :bold,
              size: 12
    text_box  "LINEUP",
              at: [358, yStart - 185],
              width: 9,
              height: 250,
              align: :center,
              style: :bold,
              size: 12
    draw_line([378, yStart - 275], [378, yStart - 35], RED, 3, nil, :up_arrow)

    # Right
    fill_color RED
    text_box  "Left Center Aisle Door",
              at: [480, yStart],
              align: :left,
              style: :bold,
              size: 12
    draw_line([575, yStart - 15], [435, yStart - 15], RED, 3, nil, :left_arrow)
    text_box  "Turn Left at the Front Row",
              at: [435, yStart - 20],
              align: :left,
              style: :bold_italic,
              size: 11
    draw_line([435, yStart - 160], [575, yStart - 160], RED, 3, nil, :right_arrow)
    text_box  "Turn Right at the Front Row",
              at: [435, yStart - 165],
              align: :left,
              style: :bold_italic,
              size: 11

    draw_position_circle(450, yStart - 55, "1", FRONT_MID_DARK)
    text_box  lineup.position_1,
              at: [480, yStart - 55],
              align: :left,
              style: :bold,
              size: 12
    draw_position_circle(450, yStart - 95, "3", FRONT_RIGHT_DARK)
    text_box  lineup.position_3,
              at: [480, yStart - 95],
              align: :left,
              style: :bold,
              size: 12
    draw_position_circle(450, yStart - 135, "5", FRONT_RIGHT_LIGHT)
    text_box  lineup.position_5,
              at: [480, yStart - 135],
              align: :left,
              style: :bold,
              size: 12
    draw_position_circle(450, yStart - 195, "11", RIGHT_WING_DARK)
    text_box  lineup.position_11,
              at: [480, yStart - 195],
              align: :left,
              style: :bold,
              size: 12
    draw_position_circle(450, yStart - 235, "9", RIGHT_WING_LIGHT)
    text_box  lineup.position_9,
              at: [480, yStart - 235],
              align: :left,
              style: :bold,
              size: 12
    draw_position_circle(450, yStart - 275, "7", BACK_MID_DARK)
    text_box  lineup.position_7,
              at: [480, yStart - 275],
              align: :left,
              style: :bold,
              size: 12

    nurseryOffset = yStart - 310
    draw_position_circle(40, nurseryOffset, "19", NURSERY)
    text_box  lineup.position_19,
              at: [70, nurseryOffset + 10],
              align: :left,
              style: :bold,
              size: 12
    text_box  "Please deliver communion to the nursery and, if applicable, kitchen staff between 11a and 11:30a",
              at: [70, nurseryOffset - 3],
              align: :left,
              style: :italic,
              size: 11

    draw_line([0, yStart - 340], [722, yStart - 340], BLACK, 3, :circle, :circle)
  end

  def draw_paths(lineup)
    draw_textbox(362, 575, 120, "Communion Table")    

    y_position = 520
    y_offset = 25
    draw_position_circle(380, y_position + 10, "1", FRONT_MID_DARK)
    draw_line([380, y_position - y_offset - 5], [380, y_position - 10], RED, 2, nil, :up_arrow, :dot)
    draw_position_circle(410, y_position - y_offset, "3", FRONT_RIGHT_DARK)
    draw_line([428, y_position - y_offset], [450, y_position - y_offset], RED, 2, nil, :right_arrow, :dot)
    draw_position_circle(470, y_position - y_offset, "5", FRONT_RIGHT_LIGHT)
    draw_line([488, y_position - y_offset], [550, y_position - y_offset], RED, 2, nil, :right_arrow, :dot)
    draw_position_circle(570, y_position - y_offset, "7", BACK_MID_DARK)
    draw_line([588, y_position - y_offset], [610, y_position - y_offset], RED, 2, nil, :right_arrow, :dot)
    draw_position_circle(630, y_position - y_offset, "9", RIGHT_WING_LIGHT)
    draw_line([648, y_position - y_offset], [670, y_position - y_offset], RED, 2, nil, :right_arrow, :dot)
    draw_position_circle(690, y_position - y_offset, "11", RIGHT_WING_DARK)
    draw_line([690, y_position - y_offset + 18], [690, y_position + 10], RED, 2, nil, nil, :dot)
    draw_line([690, y_position + 10], [400, y_position + 10], RED, 2, nil, :left_arrow, :dot)

    draw_position_circle(344, y_position + 10, "2", FRONT_MID_LIGHT)
    draw_line([344, y_position - y_offset - 5], [344, y_position - 10], RED, 2, nil, :up_arrow, :dot)
    draw_position_circle(310, y_position - y_offset, "4", FRONT_LEFT_DARK)
    draw_line([292, y_position - y_offset], [270, y_position - y_offset], RED, 2, nil, :left_arrow, :dot)
    draw_position_circle(250, y_position - y_offset, "6", FRONT_LEFT_LIGHT)
    draw_line([232, y_position - y_offset], [170, y_position - y_offset], RED, 2, nil, :left_arrow, :dot)
    draw_position_circle(150, y_position - y_offset, "8", BACK_MID_LIGHT)
    draw_line([132, y_position - y_offset], [110, y_position - y_offset], RED, 2, nil, :left_arrow, :dot)
    draw_position_circle(90, y_position - y_offset, "10", LEFT_WING_LIGHT)
    draw_line([72, y_position - y_offset], [50, y_position - y_offset], RED, 2, nil, :left_arrow, :dot)
    draw_position_circle(30, y_position - y_offset, "12", LEFT_WING_DARK)
    draw_line([30, y_position - y_offset + 18], [30, y_position + 10], RED, 2, nil, nil, :dot)
    draw_line([30, y_position + 10], [324, y_position + 10], RED, 2, nil, :right_arrow, :dot)

    stroke_color RED
    text_box "Middle Section - Front Row",
              at: [0, y_position - y_offset - 20],
              align: :center,
              style: :bold_italic,
              size: 12
    text_box "Left Section - Front Row",
              at: [0, y_position - y_offset - 20],
              align: :left,
              style: :bold_italic,
              size: 12
    text_box "Right Section - Front Row",
              at: [0, y_position - y_offset - 20],
              align: :right,
              style: :bold_italic,
              size: 12

    # Choir positions
    y_position = 580
    draw_position_circle(60, y_position, "18", CHOIR_DARK)
    text_box lineup.position_18,
              at: [80, y_position - 30],
              align: :left,
              style: :bold,
              size: 12
    draw_line([125, y_position - 20], [160, y_position], RED, 2, nil, :right_arrow, :dot)
    stroke_color BLACK
    fill_color BLACK
    text_box "Choir",
              at: [160, y_position + 15],
              align: :left,
              size: 12
    
    draw_position_circle(660, y_position, "17", CHOIR_LIGHT)
    text_box lineup.position_17,
              at: [0, y_position - 30],
              width: 640,
              align: :right,
              style: :bold,
              size: 12
    draw_line([595, y_position - 20], [560, y_position], RED, 2, nil, :left_arrow, :dot)
    stroke_color BLACK
    fill_color BLACK
    text_box "Choir",
              at: [0, y_position + 15],
              width: 560,
              align: :right,
              size: 12

    draw_line([0, 455], [722, 455], BLACK, 3, nil, nil, :dash_dot)
  end

  def draw_date(lineup)
    rotate(90, origin: [-25, 0]) do
      fill_color BLACK
      text_box  "Communion - #{lineup.service_date}",
                height: 20,
                at: [-25, 0],
                align: :left,
                size: 12,
                style: :bold
    end
  end

  def draw_choir
    draw_loft
    draw_loft_elements
    draw_loft_positions
  end

  def draw_labels
    draw_textbox(362, 436, 120, "Communion Table")
    draw_textbox(135, 250, 60, "Left")
    draw_textbox(362, 250, 60, "Center")
    draw_textbox(589, 250, 60, "Right")
    draw_textbox(362, 126, 120, "Balcony")
  end

  def draw_lower_level
    draw_wings
    draw_front_section
    draw_back_section
  end

  def draw_balcony
    draw_separator
    draw_left_balcony
    draw_mid_balcony
    draw_right_balcony
  end

  def draw_seating(lineup)
    draw_seating_name(378, 372, lineup.position_1)
    draw_position_circle(378, 372, "1", FRONT_MID_DARK)
    draw_seating_name(411, 372, lineup.position_3)
    draw_position_circle(411, 372, "3", FRONT_RIGHT_DARK)
    draw_seating_name(444, 372, lineup.position_5)
    draw_position_circle(444, 372, "5", FRONT_RIGHT_LIGHT)
    draw_seating_name(530, 372, lineup.position_7)
    draw_position_circle(530, 372, "7", BACK_MID_DARK)
    draw_seating_name(570, 372, lineup.position_9)
    draw_position_circle(570, 372, "9", RIGHT_WING_LIGHT)
    draw_seating_name(610, 372, lineup.position_11)
    draw_position_circle(610, 372, "11", RIGHT_WING_DARK)

    draw_seating_name(346, 372, lineup.position_2)
    draw_position_circle(346, 372, "2", FRONT_MID_LIGHT)
    draw_seating_name(313, 372, lineup.position_4)
    draw_position_circle(313, 372, "4", FRONT_LEFT_DARK)
    draw_seating_name(280, 372, lineup.position_6)
    draw_position_circle(280, 372, "6", FRONT_LEFT_LIGHT)
    draw_seating_name(194, 372, lineup.position_8)
    draw_position_circle(194, 372, "8", BACK_MID_LIGHT)
    draw_seating_name(154, 372, lineup.position_10)
    draw_position_circle(154, 372, "10", LEFT_WING_LIGHT)
    draw_seating_name(114, 372, lineup.position_12)
    draw_position_circle(114, 372, "12", LEFT_WING_DARK)
  end

  def draw_separator
    draw_line([5, 123], [723, 123], BLACK, 3)
    draw_line([5, 122], [723, 122], CHOIR_DARK, 4, :diamond, :diamond)
    draw_line([13, 120], [715, 120], CHOIR_LIGHT, 2)
  end

  def draw_left_balcony
    draw_section_box(135, 80, LEFT_BALCONY_DARK, LEFT_BALCONY_LIGHT, 80, 33)
    draw_section_box(135, 8, LEFT_BALCONY_DARK, LEFT_BALCONY_LIGHT, 80, 32)
    draw_position_circle(245, 95, "14", LEFT_BALCONY_LIGHT)
    draw_line([235, 85], [235, -5], LEFT_BALCONY_LIGHT, 2, nil, :circle)
    draw_line([255, 85], [255, -5], LEFT_BALCONY_LIGHT, 2, nil, :circle)
    draw_position_circle(40, 95, "16", LEFT_BALCONY_DARK)
    draw_line([40, 80], [40, -5], LEFT_BALCONY_DARK, 2, nil, :circle)

    fill_color WHITE
    stroke_color LEFT_BALCONY_DARK
    self.line_width = 2
    fill_and_stroke_rectangle [0, 70], 35, 23
    self.line_width = 1
    fill_and_stroke_circle [10, 58], 5
    fill_and_stroke_circle [25, 58], 5
  end

  def draw_mid_balcony
    draw_section_box(320, 80, LEFT_BALCONY_DARK, LEFT_BALCONY_LIGHT, 40, 33)
    draw_section_box(320, 8, LEFT_BALCONY_DARK, LEFT_BALCONY_LIGHT, 40, 32)
    draw_section_box(404, 80, RIGHT_BALCONY_DARK, RIGHT_BALCONY_LIGHT, 40, 33)
    draw_section_box(404, 8, RIGHT_BALCONY_DARK, RIGHT_BALCONY_LIGHT, 40, 32)
    draw_line([300, 90], [420, 90],   LEFT_BALCONY_LIGHT,   3, :left_arrow, :right_arrow, :dash)
    draw_line([300, 70], [420, 70],   RIGHT_BALCONY_LIGHT,  3, :left_arrow, :right_arrow, :dash)
    draw_line([300, 18], [420, 18],   LEFT_BALCONY_LIGHT,   3, :left_arrow, :right_arrow, :dash)
    draw_line([300, -2], [420, -2], RIGHT_BALCONY_LIGHT,  3, :left_arrow, :right_arrow, :dash)
  end

  def draw_right_balcony
    draw_section_box(589, 80, RIGHT_BALCONY_DARK, RIGHT_BALCONY_LIGHT, 80, 33)
    draw_section_box(589, 8, RIGHT_BALCONY_DARK, RIGHT_BALCONY_LIGHT, 80, 32)
    draw_position_circle(684, 95, "15", RIGHT_BALCONY_DARK)
    draw_line([684, 80], [684, -5], RIGHT_BALCONY_DARK, 2, nil, :circle)
    draw_position_circle(479, 95, "13", RIGHT_BALCONY_LIGHT)
    draw_line([469, 85], [469, -5], RIGHT_BALCONY_LIGHT, 2, nil, :circle)
    draw_line([489, 85], [489, -5], RIGHT_BALCONY_LIGHT, 2, nil, :circle)

    fill_color WHITE
    stroke_color LEFT_BALCONY_DARK
    self.line_width = 2
    fill_and_stroke_rectangle [690, 70], 35, 23
    self.line_width = 1
    fill_and_stroke_circle [700, 58], 5
    fill_and_stroke_circle [715, 58], 5
  end

  def draw_wings
    draw_left_wing
    draw_right_wing
  end

  def draw_front_section
    draw_front_left
    draw_front_mid
    draw_front_right
  end

  def draw_front_left
    draw_section_box(135, 310, FRONT_LEFT_DARK, FRONT_LEFT_LIGHT, 80, 45)
    draw_position_circle(230, 330, "4", FRONT_LEFT_DARK)
    draw_line([230, 315], [230, 190], FRONT_LEFT_DARK, 4, nil, :down_arrow)
    draw_position_circle(40, 330, "6", FRONT_LEFT_LIGHT)
    draw_line([40, 315], [40, 190], FRONT_LEFT_LIGHT, 4, nil, :down_arrow)
  end

  def draw_front_mid
    draw_section_box(362, 310, FRONT_MID_DARK, FRONT_MID_LIGHT, 80, 45)
    draw_position_circle(457, 330, "1", FRONT_MID_LIGHT)
    draw_line([457, 315], [457, 270], FRONT_MID_LIGHT, 4, nil, :down_arrow)
    draw_position_circle(267, 330, "2", FRONT_MID_DARK)
    draw_line([267, 315], [267, 270], FRONT_MID_DARK, 4, nil, :down_arrow)
  end

  def draw_front_right
    draw_section_box(589, 310, FRONT_RIGHT_DARK, FRONT_RIGHT_LIGHT, 80, 45)
    draw_position_circle(684, 330, "5", FRONT_RIGHT_LIGHT)
    draw_line([684, 315], [684, 190], FRONT_RIGHT_LIGHT, 4, nil, :down_arrow)
    draw_position_circle(494, 330, "3", FRONT_RIGHT_DARK)
    draw_line([494, 315], [494, 190], FRONT_RIGHT_DARK, 4, nil, :down_arrow)
  end

  def draw_back_section
    draw_back_left
    draw_back_mid
    draw_back_right
  end

  def draw_back_left
    draw_section_box(135, 203.5, FRONT_LEFT_DARK, FRONT_LEFT_LIGHT, 80, 21.5)
    draw_section_box(135, 156.5, LEFT_WING_DARK, LEFT_WING_LIGHT, 80, 21.5)
  end

  def draw_back_mid
    draw_section_box(362, 180, BACK_MID_DARK, BACK_MID_LIGHT, 80, 45)
    draw_position_circle(462, 210, "7", BACK_MID_DARK)
    draw_line([462, 195], [462, 150], BACK_MID_DARK, 4, nil, :down_arrow)
    draw_position_circle(262, 210, "8", BACK_MID_LIGHT)
    draw_line([262, 195], [262, 150], BACK_MID_LIGHT, 4, nil, :down_arrow)
  end

  def draw_back_right
    draw_section_box(589, 203.5, FRONT_RIGHT_DARK, FRONT_RIGHT_LIGHT, 80, 21.5)
    draw_section_box(589, 156.5, RIGHT_WING_DARK, RIGHT_WING_LIGHT, 80, 21.5)
  end

  def draw_left_wing
    draw_rotated_trapezoid(50, 475, 70, 50, 50, -60, LEFT_WING_DARK, LEFT_WING_LIGHT)
    draw_position_circle(123, 425, "10", LEFT_WING_LIGHT)
    draw_line([110, 416], [20, 390], LEFT_WING_LIGHT, 4, nil, :circle)
    draw_line([20, 390], [22, 240], LEFT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([22, 240], [240, 240], LEFT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([240, 240], [240, 140], LEFT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([240, 140], [230, 140], LEFT_WING_LIGHT, 4, nil, :circle, :sah)
    draw_line([230, 140], [230, 170], LEFT_WING_LIGHT, 4, nil, :up_arrow)

    draw_position_circle(50, 555, "12", LEFT_WING_DARK)
    draw_line([35, 550], [-25, 500], LEFT_WING_DARK, 4, nil, :circle)
    draw_line([-25, 500], [5, 220], LEFT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([5, 220], [23, 223], LEFT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([23, 223], [23, 140], LEFT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([23, 140], [40, 140], LEFT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([40, 140], [40, 170], LEFT_WING_DARK, 4, nil, :up_arrow)
  end

  def draw_right_wing
    draw_rotated_trapezoid(670, 475, 70, 50, 50, 60, RIGHT_WING_DARK, RIGHT_WING_LIGHT)
    draw_position_circle(595, 425, "9", RIGHT_WING_LIGHT)
    draw_line([605, 416], [705, 390], RIGHT_WING_LIGHT, 4, nil, :circle)
    draw_line([705, 390], [703, 240], RIGHT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([703, 240], [485, 240], RIGHT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([485, 240], [485, 140], RIGHT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([485, 140], [494, 140], RIGHT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([494, 140], [494, 170], RIGHT_WING_LIGHT, 4, nil, :up_arrow)

    draw_position_circle(670, 555, "11", RIGHT_WING_DARK)
    draw_line([685, 550], [745, 500], RIGHT_WING_DARK, 4, nil, :circle)
    draw_line([745, 500], [720, 220], RIGHT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([720, 220], [702, 223], RIGHT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([702, 223], [702, 140], RIGHT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([702, 140], [684, 140], RIGHT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([684, 140], [684, 170], RIGHT_WING_DARK, 4, nil, :up_arrow)
  end

  def draw_loft
    fill_color CHOIR_DARK
    stroke_color CHOIR_LIGHT
    self.line_width = 5

    fill_and_stroke_ellipse([362, 450], 210, 90)
    stroke { line [154, 465], [568, 465] }

    fill_color WHITE
    fill_rectangle [140, 463], 580, 200
  end

  def draw_loft_elements
    # Choir box
    x = 330
    y = 533
    fill_color WHITE
    fill_rectangle [x, y], 60, 20
    fill_color BLACK
    text_box "Choir",
              height: 20,
              width: 60,
              at: [x, y - 6],
              align: :center,
              size: 12,
              style: :bold

    # Piano box
    x = 185
    y = 495
    fill_color WHITE
    fill_rectangle [x, y], 60, 20
    fill_color BLACK
    text_box "Piano",
              height: 20,
              width: 60,
              at: [x, y - 6],
              align: :center,
              size: 12,
              style: :bold

    # Organ box
    x = 465
    y = 470
    rotate(90, origin: [x, y]) do
      fill_color WHITE
      fill_rectangle [x, y], 50, 20
      fill_color BLACK
      text_box "Organ",
                height: 20,
                width: 50,
                at: [x, y - 6],
                align: :center,
                size: 12,
                style: :bold
    end
  end

  def draw_loft_positions
    # Left circle and number
    draw_position_circle(168, 453, "18", CHOIR_DARK)
    draw_line([182, 453], [530, 452], CHOIR_DARK, 2, nil, :circle)

    # Right circle and number
    draw_position_circle(553, 453, "17", CHOIR_LIGHT)
    draw_line([542, 442], [200, 442], CHOIR_LIGHT, 2, nil, :circle)
  end

  def line_break_name(name)
    return name.gsub(' ', "\n")
  end

  def draw_seating_name(x, y, name)
    xOff = 12
    yOff = 20
    firstName = name.split(' ')[0]
    text_rendering_mode(:fill_stroke) do
      self.line_width = 0.5
      rotate(45, origin: [x, y]) do
        fill_color BLACK
        stroke_color WHITE
        text_box firstName || '',
                  height: 20,
                  width: 150,
                  at: [x + xOff, y + yOff],
                  align: :left,
                  size: 12,
                  style: :bold
      end
    end
  end

  def fill_names(lineup)
    fill_color WHITE

    # Fill loft names.
    draw_lineup_name(line_break_name(lineup.position_18), 250, 515)
    draw_lineup_name(line_break_name(lineup.position_17), 392, 515)

    # Fill left wing names.
    draw_lineup_name(line_break_name(lineup.position_12), 15, 520)
    draw_lineup_name(line_break_name(lineup.position_10), 15, 470)

    # Fill right wing names.
    draw_lineup_name(line_break_name(lineup.position_11), 630, 520)
    draw_lineup_name(line_break_name(lineup.position_9), 630, 470)

    # Fill left front names.
    draw_lineup_name(line_break_name(lineup.position_6), 60, 330)
    draw_lineup_name(line_break_name(lineup.position_4), 138, 330)

    # Fill mid front names.
    draw_lineup_name(line_break_name(lineup.position_2), 290, 330)
    draw_lineup_name(line_break_name(lineup.position_1), 364, 330)

    # Fill right front names.
    draw_lineup_name(line_break_name(lineup.position_3), 515, 330)
    draw_lineup_name(line_break_name(lineup.position_5), 592, 330)

    # Fill left back names.
    draw_lineup_name(line_break_name(lineup.position_6), 60, 215, 25)
    draw_lineup_name(line_break_name(lineup.position_4), 138, 215, 25)
    draw_lineup_name(line_break_name(lineup.position_12), 60, 168, 25)
    draw_lineup_name(line_break_name(lineup.position_10), 138, 168, 25)

    # Fill mid back names.
    draw_lineup_name(line_break_name(lineup.position_8), 290, 210)
    draw_lineup_name(line_break_name(lineup.position_7), 364, 210)

    # Fill right back names.
    draw_lineup_name(line_break_name(lineup.position_3), 515, 215, 25)
    draw_lineup_name(line_break_name(lineup.position_5), 592, 215, 25)
    draw_lineup_name(line_break_name(lineup.position_9), 515, 168, 25)
    draw_lineup_name(line_break_name(lineup.position_11), 592, 168, 25)

    # Fill left balcony names.
    draw_lineup_name(line_break_name(lineup.position_16), 60, 95, 35)
    draw_lineup_name(line_break_name(lineup.position_14), 138, 95, 35)

    # Fill right balcony names.
    draw_lineup_name(line_break_name(lineup.position_13), 515, 95, 35)
    draw_lineup_name(line_break_name(lineup.position_15), 592, 95, 35)

    # Test rectangle...
    # fill_color BLACK
    # fill_rectangle [15, 520], 70, 40
    # fill_color WHITE
    # fill_rectangle [15, 470], 70, 40
  end

  # Helper functions.
  def draw_lineup_name(name, x, y, height=40, width=70)
    text_box  name,
              height: height,
              width: width,
              at: [x, y],
              align: :center,
              overflow: :shrink_to_fit,
              size: 12,
              style: :bold
  end

  def draw_textbox(x, y, width, text)
    self.line_width = 2
    fill_color WHITE
    stroke_color BLACK
    fill_and_stroke_rectangle [x - width / 2, y], width, 20
    fill_color BLACK
    text_box  text,
              height: 20,
              width: width,
              at: [x - width / 2, y - 6],
              align: :center,
              size: 12,
              style: :bold
  end

  def draw_position_circle(x, y, text, color)
    self.line_width = 5
    stroke_color color
    fill_color WHITE
    fill_and_stroke_circle [x, y], 14
    fill_color BLACK
    text_box  text,
              height: 14,
              width: 14,
              at: [x - 7, y + 5],
              align: :center,
              size: 12,
              style: :bold
  end

  def draw_rotated_trapezoid(center_x, center_y, half_top_width, half_bottom_width, half_height, rotation, fill, stroke)
    fill_color fill
    stroke_color stroke
    self.line_width = 5

    center = [center_x, center_y]
    rotate rotation, origin: center do
      fill_and_stroke_polygon [center_x - half_top_width, center_y + half_height], [center_x + half_top_width, center_y + half_height], [center_x + half_bottom_width, center_y - half_height], [center_x - half_bottom_width, center_y - half_height]
    end
  end

  def draw_line(start_point, end_point, color, width, start_accent=nil, end_accent=nil, line_type=:solid)
    self.line_width = width

    if line_type == :dash
      dash(8)
    elsif line_type == :dot
      dash([width, width * 2])
    elsif line_type == :dash_dot
      dash([width * 10, width * 2, width, width * 2], phase: 12)
    end

    fill_color color
    stroke_color color
    stroke { line start_point, end_point }

    if start_accent == :circle
      fill_circle start_point, 5
    elsif start_accent == :diamond
      draw_diamond(start_point[0], start_point[1], line_width * 2)
    elsif start_accent == :left_arrow
      fill_polygon([start_point[0], start_point[1] + line_width * 2], [start_point[0], start_point[1] - line_width * 2], [start_point[0] - line_width * 2, start_point[1]])
    elsif start_accent == :right_arrow
      fill_polygon([start_point[0], start_point[1] + line_width * 2], [start_point[0], start_point[1] - line_width * 2], [start_point[0] + line_width * 2, start_point[1]])
    elsif start_accent == :up_arrow
      fill_polygon([start_point[0] + line_width * 2, start_point[1]], [start_point[0] - line_width * 2, start_point[1]], [start_point[0], start_point[1] + line_width * 2])
    elsif start_accent == :down_arrow
      fill_polygon([start_point[0] + line_width * 2, start_point[1]], [start_point[0] - line_width * 2, start_point[1]], [start_point[0], start_point[1] - line_width * 2])
    end

    if end_accent == :circle
      fill_circle end_point, 5
    elsif end_accent == :diamond
      draw_diamond(end_point[0], end_point[1], line_width * 2)
    elsif end_accent == :left_arrow
      fill_polygon([end_point[0], end_point[1] + line_width * 2], [end_point[0], end_point[1] - line_width * 2], [end_point[0] - line_width * 2, end_point[1]])
    elsif end_accent == :right_arrow
      fill_polygon([end_point[0], end_point[1] + line_width * 2], [end_point[0], end_point[1] - line_width * 2], [end_point[0] + line_width * 2, end_point[1]])
    elsif end_accent == :up_arrow
      fill_polygon([end_point[0] + line_width * 2, end_point[1]], [end_point[0] - line_width * 2, end_point[1]], [end_point[0], end_point[1] + line_width * 2])
    elsif end_accent == :down_arrow
      fill_polygon([end_point[0] + line_width * 2, end_point[1]], [end_point[0] - line_width * 2, end_point[1]], [end_point[0], end_point[1] - line_width * 2])
    end

    undash
  end

  def draw_diamond(x, y, half_width)
    fill_and_stroke_polygon([x - half_width, y], [x, y + half_width], [x + half_width, y], [x, y - half_width])
  end

  def draw_section_box(x, y, fill, stroke, half_width, half_height)
    fill_color fill
    stroke_color stroke
    self.line_width = 5

    center = [x, y]
    fill_and_stroke_rectangle [x - half_width, y + half_height], half_width * 2, half_height * 2
  end
end

    # self.join_style = :round

    # startX = 100
    # endX = 300
    # startY = 200
    # height = 100
    # segments = 15
    # stroke do
    #   move_to(startX, startY)
    #   curve_to [endX, startY], bounds: [[startX, startY], [(endX + startX) / 2, startY + height]]
    #   # (1..segments).each do |i|
    #   #   line_to((((endX - startX) / segments) * i) + startX, height / segments * i + startY)
    #   # end
    # end
    # # text "Names", align: :left, style: :bold, size: 24

    # (1..18).each do |i|
    #   text "#{i} - #{lineup["position_#{i}"] || "No Entry"}", align: :left, style: :italic, size: 14
    # end
