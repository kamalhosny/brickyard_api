module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class DecodeError < StandardError; end

  included do
    # Define custom handlers
    rescue_from(
      ActiveRecord::RecordNotFound,
      with: :four_zero_four
    )
    rescue_from(
      ExceptionHandler::AuthenticationError,
      ExceptionHandler::DecodeError,
      ExceptionHandler::ExpiredSignature,
      with: :four_zero_one
    )
    rescue_from(
      ExceptionHandler::MissingToken,
      ExceptionHandler::InvalidToken,
      ActiveRecord::RecordInvalid,
      with: :four_twenty_two
    )
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(error)
    render json: { message: error.message }, status: :unprocessable_entity
  end

  # JSON response with message; Status code 401 - Unauthorized
  def four_zero_one(error)
    render json: { message: error.message }, status: :unauthorized
  end

  # JSON response with message; Status code 404 - Not Found
  def four_zero_four(error)
    render json: { message: error.message }, status: :not_found
  end
end
