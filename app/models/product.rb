class Product < ApplicationRecord
  has_many :line_items
  has_many :orders, through: :line_items
  has_rich_text :description
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url,:locale, presence: true
  validates :title, uniqueness: true, length: {minimum: 2}
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  def description
    rich_text_description || build_rich_text_description(body: read_attribute(:description))
  end

  private
    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end

end
