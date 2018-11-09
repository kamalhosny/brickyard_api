# app/services/authenticate_user.rb
class AuthenticateUser
  attr_accessor :email, :password

  def initialize(auth_params)
    @email = auth_params[:email]
    @password = auth_params[:password]
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  def user
    user = User.find_by(email: email)
    return user if user&.authenticate(password)

    raise ExceptionHandler::AuthenticationError, 'Invalid credentials'
  end
end
