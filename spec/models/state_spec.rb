require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:order) }
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should have_many(:vehicles).dependent(:nullify) }
  end
end
