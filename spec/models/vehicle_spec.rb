require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:description) }
  end

  describe 'Callbacks' do
    it { is_expected.to callback(:set_default_values).after(:initialize) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:current_state).class_name('State') }
  end
end
