class Vehicle < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :current_state, class_name: State.name, optional: true

  ## Validations
  validates :description, presence: true
  validate :current_state_order, if: :current_state_id_changed?, on: :update

  ## Callbacks
  after_initialize :set_default_values

  ## Mehtods

  private

  def current_state_order
    old_state_order = State.find(current_state_id_was).try(:order)
    return unless (current_state.order - old_state_order).abs > 1

    errors.add(:current_state, 'can be updated only on step ahead or backword')
  end

  def set_default_values
    self.current_state ||= State.find_by(order: 1)
  end
end
