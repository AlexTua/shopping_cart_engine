module ShoppingCart
  class Address < ApplicationRecord
    belongs_to :order, optional: true, class_name: ShoppingCart::Order.name
    belongs_to :user, optional: true

    validates :first_name, :last_name, :address_name, :city,
              :zip, :country, :phone, presence: true, unless: :user_id?
    validates :first_name, :last_name, :address_name, :city, length: { maximum: 50 }
    validates :first_name, :last_name, :city,
              format: { with: /\A[A-zА-я]+\z/, message: I18n.t('messages.only_letters') }, allow_blank: :user_id?
    validates :address_name, format: { with: /\A[A-zА-я0-9\s.,-]+\z/ }, allow_blank: :user_id?
    validates :zip, length: { maximum: 10 },
                    format: { with: /\A[0-9]+\z/, message: I18n.t('messages.only_numbers') }, allow_blank: :user_id?
    validates :phone, length: { maximum: 15 },
                      format: { with: /\A^\+[0-9]+\z/, message: I18n.t('messages.phone') }, allow_blank: :user_id?
  end
end
