Spree::Variant.class_eval do
  has_many :volume_prices, :order => :position, :dependent => :destroy
  accepts_nested_attributes_for :volume_prices, :allow_destroy => true

  attr_accessible :volume_prices_attributes
  attr_accessible :current_user

  # calculates the price based on quantity
  def volume_price(quantity)
    if current_user?
      return self.price
    else
      self.volume_prices.each do |volume_price|
        if volume_price.include?(quantity)
          case volume_price.discount_type
          when 'price'
            return volume_price.amount
          when 'dollar'
            return self.price - volume_price.amount
          when 'percent'
            return self.price * (1 - volume_price.amount)
          end
        end
  end
  end
end
  

end
