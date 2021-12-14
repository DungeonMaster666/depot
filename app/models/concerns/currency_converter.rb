module CurrencyConverter
  def usd_to_euro(money)
    if I18n.locale == :es
      coef = 0.88516501
      if money.nonzero?
        converted = money/coef
        converted.round(2)
      else
        "Error"
      end
    else
      money
    end

  end
end
