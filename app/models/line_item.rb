class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity
  end

  def minus_one(line_item)
    to_update = LineItem.find(line_item.id)
    to_update.quantity = quantity - 1
    to_update.save
    puts to_update.quantity
  end

end
