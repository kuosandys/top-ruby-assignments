def stock_picker(stock_prices)
  profit_hash = {}
  stock_buy = stock_prices[0..-2]
  stock_buy.each_with_index do |buy, buy_index|
    stock_sell = stock_prices[buy_index+1..-1]
    stock_sell.each_with_index do |sell, sell_index|
      profit_hash[sell.to_i - buy.to_i] = [buy_index, buy_index+sell_index+1]
    end
  end
  max_profit = profit_hash.max_by{|profit, prices| profit}
end

puts "Enter a list of stock prices and I will tell you the best day to buy and sell for maximum profit!"
puts "Days start at 0"
puts "Please enter a list of stock prices separated by commas: "
user_input = gets.chomp.split(",")
active = true

while active
  if user_input.kind_of?(Array) && user_input.length > 1
    best_profit = stock_picker(user_input)
    puts "The maximum profit is $#{best_profit[0]} - buy on day #{best_profit.last.first} and sell on day #{best_profit.last.last}."
    active = false
  else
    puts "Please enter a valid list of stock prices! Press 'q' to quit."
    user_input = gets.chomp.split(",")
      if user_input == 'q'
        active = false
      end
  end
end