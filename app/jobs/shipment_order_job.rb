class ShipmentOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    OrderMailer.shipping(order).deliver_later
  end
end
