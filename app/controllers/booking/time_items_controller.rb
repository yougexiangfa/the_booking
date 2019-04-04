class Booking::TimeItemsController < Booking::BaseController
  before_action :set_time_list
  skip_before_action :verify_authenticity_token, only: [:select, :add_event]

  def index
    @time_items = @time_list.time_items
  end

  def select
    @time_items = @time_list.time_items

    if @time_items
      @results = @time_items.map { |x| { value: x.id, text: x.name, name: x.name } }
    end

    @time_plan = TimePlan.new

    respond_to do |format|
      format.js
      format.json { render json: { values: @results } }
    end
  end

  def add_event
    @settings = {
      minTime: @time_list.min_time,
      maxTime: @time_list.max_time,
      slotDuration: @time_list.slot_label_interval,
      slotLabelInterval: @time_list.slot_label_interval,
    }
    @events = @time_list.events(day_count)
  end

  private
  def set_time_list
    @time_list = TimeList.find params[:time_list_id]
  end

  def set_time_item
    @time_item = TimeItem.find(params[:id])
  end

  def time_item_params
    params.fetch(:time_item, {}).permit(
      :start_at,
      :finish_at,
      :position
    )
  end

end
