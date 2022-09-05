require 'csv'

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

contents.each do |row|
  name = row[:first_name]
  zip_code = row[:zipcode]

  #if zipcode is five digits then it's a correct zipcode
  #if zipcode is more than five digits chop to the first 5 digits
  #if zipcode is less than five digits fill in with zeros from the beginning

  if zip_code.length == 5
    ""
  elsif zip_code.length < 5

  elsif zip_code.length > 5

  end
  puts "#{name} #{zip_code}"
end