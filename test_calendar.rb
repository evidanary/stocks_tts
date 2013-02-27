require 'json'
require 'open-uri'
require 'market_beat'

salutation = 'Good Morning.'
weather_url = 'http://free.worldweatheronline.com/feed/weather.ashx?q=94107&format=json&num_of_days=1&key=a8371aede7074229131402'
weather_json = open(weather_url).read
weather_parsed = JSON.parse(weather_json)
weather_utterance = "Today the temperature will be a high of " +  weather_parsed['data']['weather'][0]['tempMaxF'] + " degrees with a low of " + weather_parsed['data']['weather'][0]['tempMinF'] + " degrees."

stock_list = [:T,:FB,:C,:CRM]
stock_utterance = "In Stocks. "
stock_list.each do |stock|
  gain = ((MarketBeat.change_and_percent_change(stock))[0][0] == "+" ? "gain of $ " : "loss of $ ") + (MarketBeat.change_and_percent_change(stock))[0].gsub(/[+|-]/,'')
  stock_utterance += MarketBeat.company(stock) + " is $ " + MarketBeat.opening_price(stock) + ". A net " +  gain  + "\n"
end

composite_utterance = salutation + " " + weather_utterance + " " + stock_utterance

puts composite_utterance
#`echo "#{composite_utterance}" | #{festival_path}/festival_client --port 1314  --ttw --aucommand 'afplay $FILE'`
`echo "#{composite_utterance}" | say`

