class LineupsController < ApplicationController
  before_action :set_lineup, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
    pdf = CommunionPdf.new(@lineup)
    send_data pdf.render,
              filename: "communion_lineup.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lineup
      @lineup = Lineup.find(params[:id])
    end
end