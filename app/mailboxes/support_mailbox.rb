class SupportMailbox < ApplicationMailbox
  def process
    recent_orders = Order.where(email: mail.from_address.to_s).all

    SupportRequest.create!(
      email: mail.from_address.to_s,
      subject: mail.subject,
      body: mail.body.to_s,
      order_array: recent_orders
    )

  end
end
