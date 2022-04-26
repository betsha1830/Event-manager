require 'csv'
puts 'Event Manager Initialized!'

# if File.exist?('event_attendees.csv')
#   contents = File.read('event_attendees.csv') 
#   puts contents
# else puts "file event_attendees.csv doesn't exist."
# end

# lines = File.readlines('event_attendees.csv')
# lines.each_with_index do |line, index|
#   next if index == 0
#   columns = line.split(",")
#   p columns
# end

contents = CSV.open('event_attendees.csv', headers: true)
contents.each do |item|
  name = item[2]
  puts name
end