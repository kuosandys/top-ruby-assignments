sample_prices = [17,3,6,9,15,8,6,1,10]

def stock_picker(stock_prices)
  profit_hash = {}
  stock_buy = stock_prices[0..-2]
  stock_buy.each_with_index do |buy, buy_index|
    stock_sell = stock_prices[buy_index+1..-1]
    stock_sell.each_with_index do |sell, sell_index|
      profit_hash[sell - buy] = [buy_index, buy_index+sell_index+1]
    end
  end
  max_profit_indices = profit_hash.max_by{|profit, prices| profit}[1]
end

stock_picker(sample_prices)