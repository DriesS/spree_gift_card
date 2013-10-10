module Spree
  class Calculator::GiftCard < Calculator

    def self.description
      I18n.t(:gift_card_calculator)
    end

    def compute(order, gift_card)
      # Ensure a negative amount which does not exceed the sum of the order's item_total, ship_total, and tax_total.
      [(order.item_total + order.ship_total + order.tax_total + order.promo_total), gift_card.current_value].min * -1
    end
  end
end
