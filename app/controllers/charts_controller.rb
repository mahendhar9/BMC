class ChartsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_chart, only: [:show, :update, :versionalize]

  def index
    @charts = current_user.charts.all
    @new_chart = current_user.charts.new
  end

  def create
    @chart = current_user.charts.new(chart_params)
    if @chart.save
      redirect_to chart_path(@chart)
    else
      redirect_to root_path, alert: "Something went wrong. Please try again"
    end
  end

  def show
    if params[:v]
      @chart_version = @chart.versions.where(counter: params[:v].to_i).first
    end
  end

  def update
    @chart.update_attributes(chart_update_params)

    respond_to do |format|
      format.js { render 'update' }
      format.json { respond_with_bip(@chart) }
    end
  end

  def versionalize
    @chart.versionalize!

    redirect_to chart_path(@chart, v: @chart.versions.last.counter)
  end

private
  def chart_params
    params.require(:chart).permit(:title, :description)
  end

  def chart_update_params
    params.require(:chart).permit(
      :title,
      :description,
      :customer_segments, 
      :value_propositions, 
      :customer_relationships, 
      :channels, 
      :key_activities, 
      :key_resources, 
      :key_partnerships, 
      :cost_structure, 
      :revenue_streams
    )
  end

  def fetch_chart
    @chart = current_user.charts.find(params[:id])
  end
end
