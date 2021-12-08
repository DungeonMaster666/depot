require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
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

  test "check routing number" do
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

