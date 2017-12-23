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
    draw_seating
    draw_labels

    # Now populate the positions.
    fill_names(lineup)
  end

  private

  def draw_choir
    draw_loft
    draw_loft_elements
    draw_loft_positions
  end

  def draw_labels
    draw_textbox(362, 436, 60, "Pulpit")
    draw_textbox(362, 416, 120, "Communion Table")
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

  def draw_seating
    draw_position_circle(378, 372, "1", FRONT_MID_DARK)
    draw_position_circle(411, 372, "3", FRONT_RIGHT_DARK)
    draw_position_circle(444, 372, "5", FRONT_RIGHT_LIGHT)
    draw_position_circle(530, 372, "7", BACK_MID_DARK)
    draw_position_circle(570, 372, "9", RIGHT_WING_LIGHT)
    draw_position_circle(610, 372, "11", RIGHT_WING_DARK)

    draw_position_circle(346, 372, "2", FRONT_MID_LIGHT)
    draw_position_circle(313, 372, "4", FRONT_LEFT_DARK)
    draw_position_circle(280, 372, "6", FRONT_LEFT_LIGHT)
    draw_position_circle(194, 372, "8", BACK_MID_LIGHT)
    draw_position_circle(154, 372, "10", LEFT_WING_LIGHT)
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
    draw_section_box(135, 310, FRONT_LEFT_LIGHT, FRONT_LEFT_DARK, 80, 45)
    draw_position_circle(230, 330, "4", FRONT_LEFT_DARK)
    draw_line([230, 315], [230, 270], FRONT_LEFT_DARK, 4, nil, :down_arrow)
    draw_position_circle(40, 330, "6", FRONT_LEFT_LIGHT)
    draw_line([40, 315], [40, 270], FRONT_LEFT_LIGHT, 4, nil, :down_arrow)
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
    draw_position_circle(684, 330, "3", FRONT_RIGHT_DARK)
    draw_line([684, 315], [684, 270], FRONT_RIGHT_DARK, 4, nil, :down_arrow)
    draw_position_circle(494, 330, "5", FRONT_RIGHT_LIGHT)
    draw_line([494, 315], [494, 270], FRONT_RIGHT_LIGHT, 4, nil, :down_arrow)
  end

  def draw_back_section
    draw_back_left
    draw_back_mid
    draw_back_right
  end

  def draw_back_left
    draw_section_box(135, 180, LEFT_WING_DARK, LEFT_WING_LIGHT, 80, 45)
  end

  def draw_back_mid
    draw_section_box(362, 180, BACK_MID_DARK, BACK_MID_LIGHT, 80, 45)
    draw_position_circle(462, 210, "7", BACK_MID_DARK)
    draw_line([462, 195], [462, 150], BACK_MID_DARK, 4, nil, :down_arrow)
    draw_position_circle(262, 210, "8", BACK_MID_LIGHT)
    draw_line([262, 195], [262, 150], BACK_MID_LIGHT, 4, nil, :down_arrow)
  end

  def draw_back_right
    draw_section_box(589, 180, RIGHT_WING_DARK, RIGHT_WING_LIGHT, 80, 45)
  end

  def draw_left_wing
    draw_rotated_trapezoid(50, 475, 70, 50, 50, -60, LEFT_WING_DARK, LEFT_WING_LIGHT)
    draw_position_circle(123, 425, "10", LEFT_WING_LIGHT)
    draw_line([110, 416], [20, 390], LEFT_WING_LIGHT, 4, nil, :circle)
    draw_line([20, 390], [22, 240], LEFT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([22, 240], [240, 240], LEFT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([240, 240], [240, 140], LEFT_WING_LIGHT, 4, nil, :circle)
    draw_line([240, 140], [228, 140], LEFT_WING_LIGHT, 4, nil, :circle)
    draw_line([228, 140], [228, 210], LEFT_WING_LIGHT, 4, nil, :up_arrow)

    draw_position_circle(50, 555, "12", LEFT_WING_DARK)
    draw_line([35, 550], [-25, 500], LEFT_WING_DARK, 4, nil, :circle)
    draw_line([-25, 500], [5, 220], LEFT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([5, 220], [23, 223], LEFT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([23, 223], [23, 140], LEFT_WING_DARK, 4, nil, :circle)
    draw_line([23, 140], [35, 140], LEFT_WING_DARK, 4, nil, :circle)
    draw_line([35, 140], [35, 210], LEFT_WING_DARK, 4, nil, :up_arrow)
  end

  def draw_right_wing
    draw_rotated_trapezoid(670, 475, 70, 50, 50, 60, RIGHT_WING_DARK, RIGHT_WING_LIGHT)
    draw_position_circle(595, 425, "9", RIGHT_WING_LIGHT)
    draw_line([605, 416], [705, 390], RIGHT_WING_LIGHT, 4, nil, :circle)
    draw_line([705, 390], [703, 240], RIGHT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([703, 240], [485, 240], RIGHT_WING_LIGHT, 4, nil, :circle, :dash)
    draw_line([485, 240], [485, 140], RIGHT_WING_LIGHT, 4, nil, :circle)
    draw_line([485, 140], [497, 140], RIGHT_WING_LIGHT, 4, nil, :circle)
    draw_line([497, 140], [497, 210], RIGHT_WING_LIGHT, 4, nil, :up_arrow)

    draw_position_circle(685, 555, "11", RIGHT_WING_DARK)
    draw_line([700, 550], [750, 500], RIGHT_WING_DARK, 4, nil, :circle)
    draw_line([750, 500], [720, 220], RIGHT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([720, 220], [702, 223], RIGHT_WING_DARK, 4, nil, :circle, :dash)
    draw_line([702, 223], [702, 140], RIGHT_WING_DARK, 4, nil, :circle)
    draw_line([702, 140], [690, 140], RIGHT_WING_DARK, 4, nil, :circle)
    draw_line([690, 140], [690, 210], RIGHT_WING_DARK, 4, nil, :up_arrow)
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

  def fill_names(lineup)
    fill_color WHITE

    # Fill loft names.
    draw_lineup_name(lineup.position_18, 250, 515)
    draw_lineup_name(lineup.position_17, 392, 515)

    # Fill left wing names.
    draw_lineup_name(lineup.position_12, 15, 520)
    draw_lineup_name(lineup.position_10, 15, 470)

    # Fill right wing names.
    draw_lineup_name(lineup.position_11, 630, 520)
    draw_lineup_name(lineup.position_9, 630, 470)

    # Fill left front names.
    draw_lineup_name(lineup.position_6, 60, 330)
    draw_lineup_name(lineup.position_4, 138, 330)

    # Fill mid front names.
    draw_lineup_name(lineup.position_2, 290, 330)
    draw_lineup_name(lineup.position_1, 364, 330)

    # Fill right front names.
    draw_lineup_name(lineup.position_5, 515, 330)
    draw_lineup_name(lineup.position_3, 592, 330)

    # Fill left back names.
    draw_lineup_name(lineup.position_12, 60, 210)
    draw_lineup_name(lineup.position_10, 138, 210)

    # Fill mid back names.
    draw_lineup_name(lineup.position_8, 290, 210)
    draw_lineup_name(lineup.position_7, 364, 210)

    # Fill right back names.
    draw_lineup_name(lineup.position_9, 515, 210)
    draw_lineup_name(lineup.position_11, 592, 210)

    # Fill left balcony names.
    draw_lineup_name(lineup.position_16, 60, 90)
    draw_lineup_name(lineup.position_14, 138, 90)

    # Fill right balcony names.
    draw_lineup_name(lineup.position_13, 515, 90)
    draw_lineup_name(lineup.position_15, 592, 90)

    # Test rectangle...
    # fill_color BLACK
    # fill_rectangle [15, 520], 70, 40
    # fill_color WHITE
    # fill_rectangle [15, 470], 70, 40
  end

  # Helper functions.
  def draw_lineup_name(name, x, y)
    text_box  name,
              height: 40,
              width: 70,
              at: [x, y],
              align: :center,
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
