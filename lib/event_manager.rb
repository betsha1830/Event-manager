require 'csv'

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

def clean_zipcode(zipcode)

  zipcode.to_s.rjust(5, '0')[0, 5]

end

contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]

  #if zipcode is five digits then it's a correct zipcode
  #if zipcode is more than five digits chop to the first 5 digits
  #if zipcode is less than five digits fill in with zeros from the beginning
  puts "#{name} #{clean_zipcode(zipcode)}"
end