# app/services/authenticate_user.rb
class AuthenticateUser
  attr_accessor :email, :password

  def initialize(auth_params)
    @email = auth_params[:email]
    @password = auth_params[:password]
  end

  def call
    auth_token = JsonWebToken.encode(user_id: user.id) if user
    { auth_token: auth_token, role: user.role, id: user.id }
  end

  private

  def user
    user = User.find_by(email: email)
    return user if user&.authenticate(password)

    raise ExceptionHandler::AuthenticationError, 'Invalid credentials'
  end
end
