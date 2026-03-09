class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show update destroy ranking ]

  # GET /groups
  # GET /groups?type=provincia
  def index
    @groups = if params[:type].present?
                Group.by_type(params[:type])
              else
                Group.all
              end

    render json: @groups
  end

  # GET /groups/1
  def show
    render json: @group
  end

  # GET /groups/1/ranking
  def ranking
    today_start = Time.current.beginning_of_day
    today_end = Time.current.end_of_day

    # Get all device_ids in this group
    member_device_ids = UserGroup.where(group_id: @group.id).pluck(:device_id)

    # Get today's steps for each member, summing all records
    steps_by_device = Step.where(device_id: member_device_ids)
                          .where(recorded_at: today_start..today_end)
                          .group(:device_id)
                          .sum(:count)

    # Build ranking array
    ranking = member_device_ids.map do |device_id|
      {
        device_id: device_id,
        display_name: device_id[0..7], # First 8 chars as placeholder
        steps: steps_by_device[device_id] || 0
      }
    end

    # Sort by steps descending and add rank
    ranking = ranking.sort_by { |r| -r[:steps] }
                     .each_with_index.map do |entry, index|
      entry.merge(rank: index + 1)
    end

    render json: ranking
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_content
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy!
  end

  private
    def set_group
      @group = Group.find(params.expect(:id))
    end

    def group_params
      params.expect(group: [ :name, :group_type ])
    end
end
