class User < ApplicationRecord
  ## encrypt password
  has_secure_password

  ## Enums
  enum role: { regular: 'Regular', admin: 'Admin' }

  ## Validations
  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  ## Associations
  has_many :vehicles, dependent: :destroy

  ## Callbacks
  after_initialize :set_default_values, unless: :persisted?

  ## Methods

  private

  def set_default_values
    self.role ||= :regular
  end
end
