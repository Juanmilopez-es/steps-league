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
