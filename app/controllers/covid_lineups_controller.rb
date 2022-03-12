class CovidLineupsController < ApplicationController
  before_action :set_covid_lineup, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @covid_lineup = CovidLineup.new
  end

  def create
    @covid_lineup = CovidLineup.new(covid_lineup_params)
    if @covid_lineup.save
      redirect_to covid_lineups_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @covid_lineup.update(covid_lineup_params)
      redirect_to covid_lineups_path
    else
      redirect_to edit_covid_lineup_path(@covid_lineup), alert: 'There were one or more problems saving the information. See errors below.'
    end
  end

  def destroy
    @covid_lineup.destroy!
    redirect_to covid_lineups_path
  end

  def show
    pdf = CovidCommunionPdf.new(@covid_lineup)
    send_data pdf.render,
              filename: "communion_lineup_#{@covid_lineup.service_date}.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_covid_lineup
      @covid_lineup = CovidLineup.find(params[:id])
    end

    def covid_lineup_params
      params.require(:covid_lineup).permit( :service_date,
                                      :position_1,
                                      :position_2,
                                      :position_3,
                                      :position_4,
                                      :position_5,
                                      :position_6,
                                      :position_7,
                                      :position_8)
    end
end
