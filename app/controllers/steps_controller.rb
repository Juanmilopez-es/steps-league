class StepsController < ApplicationController
  before_action :set_step, only: %i[ show update destroy ]

  # GET /steps
  def index
    @steps = Step.all

    render json: @steps
  end

  # GET /steps/1
  def show
    render json: @step
  end

  # POST /steps
  def create
    step_data = step_params

    # Upsert: one record per device per day
    Step.upsert(
      {
        device_id: step_data[:device_id],
        count: step_data[:count],
        recorded_at: Date.today
      },
      unique_by: [:device_id, :recorded_at]
    )

    @step = Step.find_by(device_id: step_data[:device_id], recorded_at: Date.today)
    render json: @step, status: :ok
  end

  # PATCH/PUT /steps/1
  def update
    if @step.update(step_params)
      render json: @step
    else
      render json: @step.errors, status: :unprocessable_content
    end
  end

  # DELETE /steps/1
  def destroy
    @step.destroy!
  end

  # GET /steps/summary?device_id=xxx
  def summary
    device_id = params[:device_id]

    if device_id.blank?
      render json: { error: "device_id is required" }, status: :bad_request
      return
    end

    yesterday = Date.yesterday
    week_start = Date.today - 6.days

    # Yesterday's steps
    yesterday_record = Step.find_by(device_id: device_id, recorded_at: yesterday)
    yesterday_steps = yesterday_record&.count || 0

    # Last 7 days data (not including today)
    week_records = Step.where(device_id: device_id, recorded_at: week_start..yesterday)

    days_active = week_records.count
    week_total = week_records.sum(:count)
    week_average = days_active > 0 ? (week_total.to_f / days_active).round : 0

    render json: {
      yesterday_steps: yesterday_steps,
      week_average: week_average,
      days_active: days_active
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_step
      @step = Step.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def step_params
      params.expect(step: [ :device_id, :count, :recorded_at ])
    end
end
