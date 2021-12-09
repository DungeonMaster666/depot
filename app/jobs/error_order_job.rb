class ErrorOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    OrderMailer.error(order).deliver_later
  end
end
