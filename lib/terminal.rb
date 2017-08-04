require "terminal/version"

module Terminal
  class Terminal
    attr_reader :pricing
    attr_reader :products

    def initialize(pricing = {}, products = [])
      @pricing = pricing
      @products = products
    end

    # set pricing with sorting by product amount
    def set_pricing pricing
      pricing.each do |code, prices|
        @pricing[code.to_s] = {}
        prices.keys.sort.each do |k|
        @pricing[code.to_s][k] = prices[k]
        end
      end
    end

    def scan product_codes
      product_codes.split("").each do |code|
        @products.push(code)
      end
    end

    def total
      products_total = get_products_total
      price = 0.0
      products_total.each do |product, amount|
        get_product_by_packs(product, amount).each do |pack|
          price += @pricing[product][pack]
        end
      end
      "$ #{'%.2f' % price}"
    end

    def next_order
      @products = []
    end

private

    def get_products_total
      products_total = Hash.new(0)
      @products.each do |code|
        products_total[code] += 1
      end
      products_total
    end

    def get_product_by_packs(product, amount)
      packs = []
      if @pricing[product].keys.include?(amount)
        packs.push(amount)
      else
        pack = @pricing[product].keys.select { |pack| pack < amount }.max
        packs.push(pack)
        packs + get_product_by_packs(product, amount - pack)
      end
    end

  end
end
