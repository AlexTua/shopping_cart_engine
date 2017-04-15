FactoryGirl.define do
  factory :address, class: ShoppingCart::Address do
    first_name "First"
    last_name "Last"
    address_name "Street"
    city "City"
    zip "12345"
    country "Ukraine"
    phone "+3347645754"
  end
end