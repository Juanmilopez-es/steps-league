class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show update destroy ]

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
