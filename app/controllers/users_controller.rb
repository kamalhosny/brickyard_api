class UsersController < ApplicationController
  before_action :prepare_user, only: :show

  def show
    render json: @user, status: :ok
  end

  private

  def prepare_user
    @user = User.find(params[:id])
  end
end
