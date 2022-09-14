require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

template_letter = File.read('form_letter.html')
contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0, 5]
end

def clean_phone_number(phone_number)

  #If the phone number is less than 10 digits, assume that it is a bad number -
  #If the phone number is 10 digits, assume that it is good
  #If the phone number is 11 digits and the first number is 1, trim the 1 and use the remaining 10 digits
  #If the phone number is 11 digits and the first number is not 1, then it is a bad number 
  #If the phone number is more than 11 digits, assume that it is a bad number -
  #Remove any spaces or signs from number

  while phone_number =~ /\D/
    index = phone_number =~ /\D/
    phone_number[index] = ''
  end
  
  phone_number = phone_number.to_s

  if phone_number.length < 10 || phone_number.length > 11 || (phone_number.length == 11 && phone_number[0] != '1')
    ""
  elsif phone_number.length == 10
    phone_number
  else
    phone_number = phone_number[1..10]
  end

end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  filename = "output/thanks_#{id}.html"
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def reg_time_counter(reg_date)
  user_reg_at_hours = {}

  date = Time.parse(reg_date)
  hour = date.strftime('%k').strip
  user_reg_at_hours.include?(hour) ? user_reg_at_hours[hour] += 1 : user_reg_at_hours[hour] = 1
  user_reg_at_hours
end

def time_filter(start_hour,end_hour) 
  
end

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone_number = clean_phone_number(row[:homephone])
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)
  # save_thank_you_letter(id,form_letter)

end