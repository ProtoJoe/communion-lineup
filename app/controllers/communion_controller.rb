class CommunionController < ApplicationController
  def index
  end

  def generate
    pdf = CommunionPdf.new(params[:names])
    send_data pdf.render,
              filename: "communion_lineup.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end
end
