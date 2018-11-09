FactoryBot.define do
  factory :state do
    name { Faker::Lorem.word }
    order { State.count + 1 }

    trait :without_order do
      order { nil }
    end

    trait :without_name do
      name { nil }
    end
  end
end
