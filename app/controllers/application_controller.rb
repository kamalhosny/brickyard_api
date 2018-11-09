class ApplicationController < ActionController::API
  include ExceptionHandler

  before_action :authorize_request
  attr_reader :current_user, :current_admin

  private

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call
    @current_admin = @current_user if @current_user&.admin?
  end

  def authenticate_admin
    return if @current_admin

    raise ExceptionHandler::AuthenticationError, 'This action can be done by admins only'
  end

  def authorize_user
    user = User.find(params[:user_id])
    return if user.id == current_user.id || current_admin

    raise ExceptionHandler::AuthenticationError, 'you are not authorized to do this action'
  end
end
