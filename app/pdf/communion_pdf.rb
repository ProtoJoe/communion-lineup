class CommunionPdf < Prawn::Document
  def initialize(lineup)
    super()

    # Basic font options.
    font 'Helvetica', style: :normal

    near_white = 'DDDDDD'
    light_grey = '959595'
    dark_grey = '3C3C3C'
    white = 'FFFFFF'
    black = '000000'

    text "Names", align: :left, style: :bold, size: 24

    (1..18).each do |i|
      text "#{i} - #{lineup["position_#{i}"] || "No Entry"}", align: :left, style: :italic, size: 14
    end
  end
end
  