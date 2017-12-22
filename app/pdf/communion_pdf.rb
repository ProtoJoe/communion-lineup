class CommunionPdf < Prawn::Document
  def initialize(names)
    super()

    # Basic font options.
    font 'Helvetica', style: :normal

    near_white = 'DDDDDD'
    light_grey = '959595'
    dark_grey = '3C3C3C'
    white = 'FFFFFF'
    black = '000000'

    # Order Header
    text "Names", align: :right, style: :bold, size: 24
    if names
      names.each do |name|
        text name, align: :left, style: :italic, size: 14
      end
    end
  end
end
  