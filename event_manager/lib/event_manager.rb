require "csv"
require "sunlight"
require "erb"
require "Date"

Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_for_zipcode(zipcode)
	Sunlight::Legislator.all_in_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
	Dir.mkdir("output") unless Dir.exists? "output"

	filename = "output/thanks_#{id}.html"

	File.open(filename, "w") do |file|
		file.puts form_letter
	end
end

def clean_homephone(homephone)
	homephone.gsub!(/[-.() ]/, "") if !homephone.nil?

	if homephone.nil?
		homephone = "0" * 10
	elsif homephone.length < 10
		homephone = "0" * 10
	elsif homephone.length == 11 && homephone[0].to_i == 1
		homephone[1..10]
	elsif homephone.length == 11 && homephone[0].to_i != 1
		homephone = "0" * 10
	elsif homephone.length > 11
		homephone = "0" * 10
	else
		homephone
	end
end

puts "EventManager initialized."

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
	id = row[0]
	name = row[:first_name]
	zipcode = clean_zipcode(row[:zipcode])
	homephone = clean_homephone(row[:homephone])
	registration_date = DateTime.strptime(row[:regdate], "%Y/%d/%m %H:%M")
	legislators = legislators_for_zipcode(zipcode)

	form_letter = erb_template.result(binding)

	# puts homephone + " " + registration_date.hour.to_s + " " + registration_date.wday.to_s
	puts "#{homephone} #{registration_date.hour.to_s} #{registration_date.wday.to_s}"

	save_thank_you_letters(id, form_letter)
end