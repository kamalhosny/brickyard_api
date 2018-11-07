class User < ApplicationRecord
  ## encrypt password
  has_secure_password

  ## Enums
  enum role: { default: 'Default', admin: 'Admin' }

  ## Validations
  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  ## Callbacks
  after_initialize :set_default_values, unless: :persisted?

  ## Methods
  def set_default_values
    self.role ||= :default
  end
end
