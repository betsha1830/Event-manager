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

def zipcode_handler (zipcode)
  index = 0
  if zipcode.nil?
    zipcode = '00000'
  elsif zipcode.length < 5
    index = zipcode.length
    while index < 5
      zipcode = "0#{zipcode}"
      index += 1
    end
    zipcode
  elsif zipcode.length > 5
    zipcode = zipcode.slice(0, 5)
  else zipcode
  end
end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
contents.each do |item|

  name = item[:first_name]
  zipcode = item[:zipcode]

  # If the zip code is less than five digits, add zeros to the front until it becomes five digits
  # If a zipcode is more than 5 digits chop the the first 5 digits to store

  zipcode = zipcode_handler(item[:zipcode])

  puts "#{name}, #{zipcode}"
end