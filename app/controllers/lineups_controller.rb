class LineupsController < ApplicationController
  before_action :set_lineup, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @lineup = Lineup.new
  end

  def create
    @lineup = Lineup.new(lineup_params)
    if @lineup.save
      redirect_to lineup_path(@lineup)
    else
      render 'new'
    end
end

  def show
    pdf = CommunionPdf.new(@lineup)
    send_data pdf.render,
              filename: "communion_lineup_#{@lineup.service_date}.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lineup
      @lineup = Lineup.find(params[:id])
    end

    def lineup_params
      params.require(:lineup).permit( :service_date,
                                      :position_1,
                                      :position_2,
                                      :position_3,
                                      :position_4,
                                      :position_5,
                                      :position_6,
                                      :position_7,
                                      :position_8,
                                      :position_9,
                                      :position_10,
                                      :position_11,
                                      :position_12,
                                      :position_13,
                                      :position_14,
                                      :position_15,
                                      :position_16,
                                      :position_17,
                                      :position_18)
    end
end
