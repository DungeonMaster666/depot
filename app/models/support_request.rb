class SupportRequest < ApplicationRecord
  serialize :order_array
  has_rich_text :response
end

