FactoryBot.define do
  factory :tweet do
    body { Faker::Lorem.sentence }
    association :user
  end
end
