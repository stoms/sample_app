FactoryGirl.define do
  factory :user do
    name                  'Stephen Toms'
    email                 'st@st100.plus.com'
    password              'foobar'
    password_confirmation 'foobar'
  end
end
