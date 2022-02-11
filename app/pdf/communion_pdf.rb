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

    # Now populate the positions.
    fill_names(lineup)

    # Label the document.
    draw_date(lineup)
  end

  private

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
  end

  def draw_labels
    draw_textbox(362, 436, 120, "Altar")
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

  def draw_separator
    draw_line([5, 123], [723, 123], BLACK, 3)
    draw_line([5, 122], [723, 122], CHOIR_DARK, 4, :diamond, :diamond)
    draw_line([13, 120], [715, 120], CHOIR_LIGHT, 2)
  end

  def draw_left_balcony
    draw_section_box(135, 80, LEFT_BALCONY_DARK, LEFT_BALCONY_LIGHT, 80, 33)
    draw_section_box(135, 8, LEFT_BALCONY_DARK, LEFT_BALCONY_LIGHT, 80, 32)
  end

  def draw_mid_balcony
    draw_section_box(320, 80, LEFT_BALCONY_DARK, LEFT_BALCONY_LIGHT, 40, 33)
    draw_section_box(320, 8, LEFT_BALCONY_DARK, LEFT_BALCONY_LIGHT, 40, 32)
    draw_section_box(404, 80, RIGHT_BALCONY_DARK, RIGHT_BALCONY_LIGHT, 40, 33)
    draw_section_box(404, 8, RIGHT_BALCONY_DARK, RIGHT_BALCONY_LIGHT, 40, 32)
  end

  def draw_right_balcony
    draw_section_box(589, 80, RIGHT_BALCONY_DARK, RIGHT_BALCONY_LIGHT, 80, 33)
    draw_section_box(589, 8, RIGHT_BALCONY_DARK, RIGHT_BALCONY_LIGHT, 80, 32)
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
  end

  def draw_front_mid
    draw_section_box(362, 310, FRONT_MID_DARK, FRONT_MID_LIGHT, 80, 45)
  end

  def draw_front_right
    draw_section_box(589, 310, FRONT_RIGHT_DARK, FRONT_RIGHT_LIGHT, 80, 45)
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
  end

  def draw_back_right
    draw_section_box(589, 203.5, FRONT_RIGHT_DARK, FRONT_RIGHT_LIGHT, 80, 21.5)
    draw_section_box(589, 156.5, RIGHT_WING_DARK, RIGHT_WING_LIGHT, 80, 21.5)
  end

  def draw_left_wing
    draw_rotated_trapezoid(50, 475, 70, 50, 50, -60, LEFT_WING_DARK, LEFT_WING_LIGHT)
  end

  def draw_right_wing
    draw_rotated_trapezoid(670, 475, 70, 50, 50, 60, RIGHT_WING_DARK, RIGHT_WING_LIGHT)
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
    x = 385
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
    x = 495
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

  def line_break_name(name)
    return name.gsub(' ', "\n")
  end

  def fill_names(lineup)
    fill_color WHITE

    draw_position_circle(143, 425, "1", LEFT_WING_LIGHT)
    draw_lineup_name(line_break_name(lineup.position_1), 143, 410)

    draw_position_circle(575, 425, "2", RIGHT_WING_LIGHT)
    draw_lineup_name(line_break_name(lineup.position_2), 505, 410)

    draw_position_circle(30, 150, "3", FRONT_LEFT_LIGHT)
    draw_lineup_name(line_break_name(lineup.position_3), -5, 200)

    draw_position_circle(247, 150, "4", FRONT_MID_LIGHT)
    draw_lineup_name(line_break_name(lineup.position_4), 212, 200)

    draw_position_circle(473, 150, "5", BACK_MID_LIGHT)
    draw_lineup_name(line_break_name(lineup.position_5), 438, 200)

    draw_position_circle(695, 150, "6", FRONT_RIGHT_LIGHT)
    draw_lineup_name(line_break_name(lineup.position_6), 660, 200)

    draw_position_circle(30, 100, "7", LEFT_BALCONY_LIGHT)
    draw_lineup_name(line_break_name(lineup.position_7), -5, 80)

    draw_position_circle(695, 100, "8", RIGHT_BALCONY_LIGHT)
    draw_lineup_name(line_break_name(lineup.position_8), 660, 80)
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
