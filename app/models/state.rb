class State < ApplicationRecord
  acts_as_list column: :order
  ## Associations
  has_many :vehicles, foreign_key: :current_state_id,
                      inverse_of: :current_state,
                      dependent: :nullify

  ## Validations
  validates :name, presence: true
  validate :order_must_not_exceed_states_count

  ## Callbacks
  after_initialize :set_default_values, if: :new_record?
  before_destroy :remove_state_from_list
  after_update :update_states_order, if: :saved_change_to_order?
  after_create :update_states_order, unless: :created_sequentially?

  ## Methods

  private

  def set_default_values
    self.order ||= State.count + 1
  end

  def created_sequentially?
    order == State.count + 1
  end

  def order_must_not_exceed_states_count
    return if order && ((order - State.count < 1 && persisted?) || (order - State.count <= 1 && new_record?))

    errors.add(:order, 'should be sequential and not exceed the number of the states')
  end

  def update_states_order
    return if order.nil?

    insert_at(order)
  end

  def remove_state_from_list
    remove_from_list
  end
end
