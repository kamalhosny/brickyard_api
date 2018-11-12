class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: :create

  # LogIn
  def create
    result = AuthenticateUser.new(prepare_auth_params).call
    render json: result, status: :ok
  end

  private

  def prepare_auth_params
    params.permit(:email, :password)
  end
end
