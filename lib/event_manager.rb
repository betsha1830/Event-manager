puts 'Event Manager Initialized!'

# if File.exist?('event_attendees.csv')
#   contents = File.read('event_attendees.csv') 
#   puts contents
# else puts "file event_attendees.csv doesn't exist."
# end

lines = File.readlines('event_attendees.csv')

lines.each do |line|
  columns = line.split(",")
  p columns[2]
end