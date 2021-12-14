require 'pry'
class StoreController < ApplicationController
  skip_before_action :authorize
  include CurrentCart
  include CurrencyConverter
  before_action :set_cart
  def index

    @book_languages = Product.pluck(:locale).uniq
    @book_languages.unshift("All")

    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else


      if params[:book_locale] == "All"
        @products = Product.order(:title)
      elsif params[:book_locale]

        @products = Product.where(locale: params[:book_locale]).order(:title)

      else
        @products = Product.order(:title)
      end
    end
  end
end
