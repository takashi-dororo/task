FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'RSpecのFactoryの勉強' }
    user
  end
end
