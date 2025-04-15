require "http"
require "json"
require "dotenv/load"


pp "Where are you located?"

user_location = gets.chomp


map_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

resp = HTTP.get(map_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)

results =  parsed_response.fetch("results")
first_result = results.at(0)
location = first_result.fetch("geometry").fetch("location")
latitude = location.fetch("lat")
longitude = location.fetch("lng")

puts "Your coordinates are #{latitude}, #{longitude}."

weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/#{latitude},#{longitude}"
response = HTTP.get(weather_url).to_s
parsed_response =  JSON.parse(response)
current = parsed_response.fetch("currently")
temperature = current.fetch("temperature")

pp "It is currently #{temperature}°F."


minutely_hash = parsed_response.fetch("minutely", false)

if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary")
  puts "Next hour: #{next_hour_summary}"
end

precip = false

hourly_hash = parsed_response.fetch("hourly")
hour_data = hourly_hash.fetch("data")
next_twelve_hours = hour_data[1..12]

precip_threshold = 0.1
next_twelve_hours.each do |hour_hash|
  precip_prob = hour_hash.fetch("precipProbability")
  if precip_prob > precip_threshold
    precip = true
    time = Time.at(hour_hash.fetch("time"))
    seconds_from_now = time - Time.now
    hours_from_now = seconds_from_now / 60 / 60
   
    puts "In #{hours_from_now.round} hours, there is a #{(precip_prob)*100.round}% chance of precipitation."
  end
end

if precip == false
  puts "You probably won't need an umbrella today"
else
  puts "You might want to carry an umbrella!"
    
end
