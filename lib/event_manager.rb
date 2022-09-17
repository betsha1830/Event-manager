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

def reg_time_counter
  user_reg_at_hours = {}
  attendees = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
  attendees.each do |attendee|
    reg_date = attendee[:regdate]
    date = Time.strptime(reg_date, '%m/%d/%y %H')
    hour = date.strftime('%k').strip
    user_reg_at_hours.include?(hour) ? user_reg_at_hours[hour] += 1 : user_reg_at_hours[hour] = 1
  end
  user_reg_at_hours
end

def reg_dow_counter
  user_reg_dow = {}
  attendees = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
  attendees.each do |attendee|
    reg_date = attendee[:regdate]
    date = Time.strptime(reg_date, '%m/%d/%y').wday
    user_reg_dow.include?(date) ? user_reg_dow[date] += 1 : user_reg_dow[date] = 1
  end
  user_reg_dow
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
  save_thank_you_letter(id,form_letter)

end