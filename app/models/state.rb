class State < ApplicationRecord
  ## Associations
  has_many :vehicles, foreign_key: :current_state_id,
                      inverse_of: :current_state,
                      dependent: :nullify

  ## Validations
  validates :name, :order, presence: true
  validate :order_must_not_exceed_states_count

  ## Callbacks
  before_save :update_states_order, if: :states_order_changed?

  ## Methods

  private

  def states_order_changed?
    (persisted? && order_changed?) || (new_record? && order != State.count + 1)
  end

  def order_must_not_exceed_states_count
    return if order && order - State.count <= 1

    errors.add(:order, 'should be sequential')
  end

  def update_states_order
    state = State.find_by(order: order)
    if new_record?
      state&.update_columns(order: State.maximum(:order) + 1, updated_at: Time.current)
    else
      state&.update_columns(order: order_was, updated_at: Time.current)
    end
  end
end
