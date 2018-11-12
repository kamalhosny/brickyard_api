class VehiclesController < ApplicationController
  before_action :authorize_user
  before_action :prepare_vehicle, only: %i[show update destroy]
  before_action :prepare_user

  def index
    vehicles = @user.vehicles.includes(:current_state)
    render json: vehicles.to_json(include: :current_state)
  end

  def show
    render json: @vehicle.to_json(include: :current_state)
  end

  def create
    vehicle = Vehicle.new(vehicle_params)

    if vehicle.save
      render json: vehicle.to_json(include: :current_state), status: :created
    else
      render json: vehicle.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      render json: @vehicle.to_json(include: :current_state)
    else
      render json: @vehicle.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle.destroy
  end

  private

  def prepare_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def prepare_user
    @user = User.find(params[:user_id])
  end

  def vehicle_params
    params.require(:vehicle).permit(:description, :user_id, :current_state_id)
  end
end
