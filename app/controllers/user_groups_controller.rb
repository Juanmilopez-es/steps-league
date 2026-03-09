class UserGroupsController < ApplicationController
  before_action :set_user_group, only: %i[ show update destroy ]

  # GET /user_groups
  # GET /user_groups?device_id=abc123
  def index
    @user_groups = if params[:device_id].present?
                     UserGroup.where(device_id: params[:device_id]).includes(:group)
                   else
                     UserGroup.all.includes(:group)
                   end

    render json: @user_groups, include: :group
  end

  # GET /user_groups/1
  def show
    render json: @user_group, include: :group
  end

  # POST /user_groups
  def create
    @user_group = UserGroup.new(user_group_params)

    if @user_group.save
      render json: @user_group, include: :group, status: :created, location: @user_group
    else
      render json: @user_group.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /user_groups/1
  def update
    if @user_group.update(user_group_params)
      render json: @user_group, include: :group
    else
      render json: @user_group.errors, status: :unprocessable_content
    end
  end

  # DELETE /user_groups/1
  def destroy
    @user_group.destroy!
    head :no_content
  end

  # DELETE /user_groups/leave?device_id=abc&group_id=1
  def leave
    @user_group = UserGroup.find_by(device_id: params[:device_id], group_id: params[:group_id])
    if @user_group
      @user_group.destroy!
      head :no_content
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end

  private
    def set_user_group
      @user_group = UserGroup.find(params.expect(:id))
    end

    def user_group_params
      params.expect(user_group: [ :device_id, :group_id ])
    end
end
