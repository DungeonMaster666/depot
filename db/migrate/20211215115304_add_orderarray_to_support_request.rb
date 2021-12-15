class AddOrderarrayToSupportRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :support_requests, :order_array, :textrail
  end
end
