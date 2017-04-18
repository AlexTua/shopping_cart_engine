FactoryGirl.define do
  factory :order_item, class: ShoppingCart::OrderItem do
    book
    order
    quantity 5
  end
end
