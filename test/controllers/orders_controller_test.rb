require "test_helper"
require 'pry'
class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @order_create = orders(:test)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "requires item in cart" do
    get new_order_url
    assert_redirected_to store_index_path
    assert_equal flash[:notice], 'Your cart is empty'
  end

  test "should get new" do
    post line_items_url, params: { product_id: products(:ruby).id }
    get new_order_url
    assert_response :success
  end


  test "should create order" do
    if @order_create.line_items.any?
      assert_difference('Order.count') do
        post orders_url, params: { order: { address: "test", email: "test@test.com", name: "Test", pay_type: "Check" } }
      end

      assert_redirected_to store_index_url(locale: I18n.locale)

    else

      assert_redirected_to "http://localhost:3000/admin?locale=en"

    end
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type, ship_date: @order.ship_date } }
    assert_redirected_to order_url(@order)
  end



  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
