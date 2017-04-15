module ShoppingCart
  class Order < ApplicationRecord
    include AASM

    before_save { update_total_price }

    has_many :order_items, dependent: :destroy, class_name: 'ShoppingCart::OrderItem'
    has_many :addresses, dependent: :destroy, class_name: 'ShoppingCart::Address'
    belongs_to :user, optional: true
    belongs_to :delivery, optional: true, class_name: 'ShoppingCart::Delivery'
    belongs_to :credit_card, optional: true, class_name: 'ShoppingCart::CreditCard'

    SORT_TITLES = {all: "All", in_progress: "In Progress", in_queuen: "Waiting for processing",
                   in_delivery: "In Delivery", delivered: "Delivered", canceled: "Canceled"}.freeze

    default_scope { order(created_at: :desc) }
    scope :in_progress, -> { where(state: :in_progress) }
    scope :in_queuen, -> { where(state: :in_queuen) }
    scope :in_delivery, -> { where(state: :in_delivery) }
    scope :delivered, -> { where(state: :delivered) }

    aasm column: 'state', whiny_transitions: false do
      state :in_progress, initial: true
      state :in_queuen, :in_delivery, :delivered, :canceled

      event :confirm do
        after do
          ShoppingCart::CheckoutMailer.complete_email(user, self).deliver_now
        end
        transitions from: :in_progress, to: :in_queuen
      end

      event :start_delivery do
        transitions from: :in_queuen, to: :in_delivery
      end

      event :finish_delivery do
        transitions from: :in_delivery, to: :delivered
      end

      event :cancel do
        transitions from: [:in_queuen, :in_delivery, :in_progress], to: :canceled
      end
    end


    def subtotal
      order_items.collect(&:total_price).sum
    end

    def get_address(type)
      return addresses.first if addresses.first.try(:address_type) == "both"
      addresses.select { |address| address.address_type == type }[0]
    end

    def track_number
      "R" + id.to_s
    end

    private

    def use_coupon 
      return 0 if coupon >= subtotal
      coupon
    end

    def update_total_price
      self.total_price = subtotal - use_coupon + (delivery.nil? ? 0 : delivery.price)
    end
  end
end