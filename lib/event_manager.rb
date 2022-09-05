require 'csv'

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

def clean_zipcode(zipcode)

  if zipcode == nil || zipcode.length < 5
    zipcode = "" if zipcode.nil?
    until zipcode.length == 5
      zipcode = "0" + zipcode
    end
  elsif zipcode.length > 5
    zipcode = zipcode[0,4]
  end

end

contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]

  #if zipcode is five digits then it's a correct zipcode
  #if zipcode is more than five digits chop to the first 5 digits
  #if zipcode is less than five digits fill in with zeros from the beginning
  puts "#{name} #{zipcode}"
end