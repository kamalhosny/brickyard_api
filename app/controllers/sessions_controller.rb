class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: :create

  # LogIn
  def create
    auth_token = AuthenticateUser.new(prepare_auth_params).call
    render json: { auth_token: auth_token }, status: :ok
  end

  private

  def prepare_auth_params
    params.permit(:email, :password)
  end
end
