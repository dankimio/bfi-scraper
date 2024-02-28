require 'json'
require 'dotenv'
require 'themoviedb'

# Read data from data.json
file = File.read('data.json')
data = JSON.parse(file)

Dotenv.load
Tmdb::Api.key(ENV['THEMOVIEDB_API_KEY'])

# Iterate through each item
data.each do |item|
  title = item['title']
  year = item['year']

  # # Search TMDB for the query
  search = Tmdb::Search.new
  search.resource('movie')
  search.query(title)
  search.year(year)
  result = search.fetch

  next unless result.any?

  # # Get the TMDB ID from the result
  tmdb_id = result.first['id']

  # # Assign TMDB ID to the item
  item['tmdb_id'] = tmdb_id
end

# Save the updated data back to data.json
File.open('data_with_tmdb.json', 'w') do |file|
  file.write(data.to_json)
end
