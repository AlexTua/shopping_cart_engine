module ShoppingCart
  class OrderDecorator < Draper::Decorator
    delegate_all

    def track_number
      "R" + id.to_s
    end
  end
end