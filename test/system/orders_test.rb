require "application_system_test_case"
require 'pry'
require 'colorize'

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "update shipment date" do

    visit orders_url
    click_on "Edit", match: :first
    fill_in 'order_ship_date', with: "12.05.2023"

    perform_enqueued_jobs do
      click_button "Place Order"
    end

    order = Order.order("updated_at").last

    assert_equal "12.05.2023", order.ship_date.strftime("%d.%m.%Y")

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["MyString"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Ship Date", mail.subject

  end

  test "destroying a Order" do
    visit orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed"
  end

  test "add to cart" do
    visit store_index_url
    assert_no_selector "h2", text: "Your Cart"
    click_on 'Add to Cart', match: :first
    assert_selector "h2", text: "Your Cart"
  end

  test 'hide cart' do
    visit store_index_url
    assert_no_selector "h2", text: "Your Cart"
    click_on 'Add to Cart', match: :first
    assert_selector "h2", text: "Your Cart"
    page.accept_confirm do
      click_on 'Empty cart', match: :first
    end
    assert_no_selector "h2", text: "Your Cart"

  end



  test "check routing number and succeeded" do
    LineItem.delete_all
    Order.delete_all
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'
    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'
    assert_no_selector "#order_account_number"
    assert_no_selector "#order_routing_number"
    select 'Check', from: 'Pay type'
    assert_selector "#order_routing_number"
    assert_selector "#order_account_number"

    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "78910"

    perform_enqueued_jobs do
      click_button "Place Order"
    end

    if Order.last.succeed==false
      assert_text "Thank you for your order. Check your email as soon as possible!"
      order = Order.last

      assert_equal false, order.succeed

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["dave@example.com"], mail.to
      assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
      assert_equal "Pragmatic Store Order Error", mail.subject

    elsif Order.last.succeed==true
      assert_text "Thank you for your order. Check your email as soon as possible!"
      order = Order.last
      assert_equal true, order.succeed



      assert_equal "Dave Thomas", order.name
      assert_equal "123 Main Street", order.address
      assert_equal "dave@example.com", order.email
      assert_equal "Check", order.pay_type
      assert_equal 1, order.line_items.size

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["dave@example.com"], mail.to
      assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
      assert_equal "Pragmatic Store Order Confirmation", mail.subject
    end


  end

  test "credit card" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'
    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'
    assert_no_selector "#order_credit_card_number"
    assert_no_selector "#order_expiration_date"

    select 'Credit card', from: 'Pay type'
    assert_selector "#order_credit_card_number"
    assert_selector "#order_expiration_date"

  end

  test "Purchase" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'
    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'
    assert_no_selector "#order_po_number"

    select 'Purchase order', from: 'Pay type'
    assert_selector "#order_po_number"

  end



end

