class StatesController < ApplicationController
  before_action :authenticate_admin, only: %i[create update destroy]
  before_action :prepare_state, only: %i[show update destroy]

  def index
    states = State.all.order(:order)

    render json: states
  end

  def show
    render json: @state
  end

  def create
    state = State.new(state_params)
    if state.save
      render json: state, status: :created
    else
      render json: state.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @state.update(state_params)
      render json: @state
    else
      render json: @state.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @state.destroy
  end

  private

  def prepare_state
    @state = State.find(params[:id])
  end

  def state_params
    params.require(:state).permit(:name, :order)
  end
end
