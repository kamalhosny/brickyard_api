FactoryBot.define do
  factory :vehicle do
    description { Faker::Vehicle.make_and_model }
    user
    current_state { create(:state) }
  end
end
