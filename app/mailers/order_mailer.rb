class OrderMailer < ApplicationMailer
  default from: 'Sam Ruby <depot@example.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
  end

  def error(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Error'
  end

  def shipping(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Ship Date'
  end
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order
    @disable_remove_items = true
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end
end
