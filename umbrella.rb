require "http"
require "json"
require "dotenv/load"


pp "Where are you located?"

#  user_location = gets.chomp

user_location = "Chicago"

map_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

resp = HTTP.get(map_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)

results =  parsed_response.fetch("results")
first_result = results.at(0)
location = first_result.fetch("geometry").fetch("location")
latitude = location.fetch("lat")
longitude = location.fetch("lng")

pp latitude
pp longitude

weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/#{latitude},#{longitude}"
response = HTTP.get(weather_url).to_s
parsed_response =  JSON.parse(response)
current = parsed_response.fetch("currently")
temperature = current.fetch("temperature")

pp "It is currently #{temperature}°F."



# currently_hash = parsed_response.fetch("currently")

# current_temp = currently_hash.fetch("temperature")

# puts "The current temperature is " + current_temp.to_s + "."
