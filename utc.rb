#!/usr/bin/env ruby
require 'optparse'

mypath = File.dirname(__FILE__)

def with_time_zone(tz_name)
	prev_tz = ENV['TZ']
	ENV['TZ'] = tz_name
	yield
ensure
	ENV['TZ'] = prev_tz
end	

# Define the timezones this utility is designed to work with
TIMEZONES = %w[Canada/Atlantic Canada/Central Canada/Eastern Canada/East-Saskatchewan Canada/Mountain Canada/Newfoundland Canada/Pacific Canada/Saskatchewan Canada/Yukon]
TIMEZONE_ALIASES = {
	"AT" => "Canada/Atlantic",
	"CT" => "Canada/Central",
	"ET" => "Canada/Eastern",
	"ES" => "Canada/East-Saskatchewan",
	"MT" => "Canada/Mountain",
	"NT" => "Canada/Newfoundland",
	"PT" => "Canada/Pacific",
	"SK" => "Canada/Saskatchewan",
	"YT" => "Canada/Yukon" }

# Print a list of supported timezones
def list_timezones
	TIMEZONE_ALIASES.each do |k,v|
		puts k + "\t"+ v
	end
end

# Collect the options in an array	
options = {} 

# Create a new OptionParser object
optparse = OptionParser.new do |opts| 
	# Display a banner at the top of a help page.  
	opts.banner = "Usage: Convert times between UTC and any Canadian timezone."

	# Set the -u flag to convert a UTC time to local time or any other
	# Canadian time zone, as defined by the -t option
	options[:utc] = false
	opts.on( '-u', '--utc', 'Convert UTC time to local time or time defined by the -t flag.') do
		options[:utc] = true
	end

	# Set the timezone of interest to/from which to convert UTC
	timezone_list = (TIMEZONE_ALIASES.keys + TIMEZONES).join(',')
	options[:tz] = ""
	opts.on("-t", "--timezone TIMEZONE", TIMEZONES, TIMEZONE_ALIASES, "Select timezone (see -l flag)",
		) do |timezone|
		options[:tz] = timezone
	end
	
	# List the timezones suported by the app. 
	options[:list] = TIMEZONE_ALIASES
        opts.on( '-l', '--list', 'List all supported timezones') do
		list_timezones
		exit
	end
	
	# Display a user manual for this utility
	opts.on("-m", "--manual", "Display a user manual for how to use the utc utility.") do
		exec "man #{mypath}/utc.1"	
		exit
	end

	# Display the help screen.
	opts.on( '-h', '--help', 'Display this screen') do
		puts opts
		exit
	end
end  

# This is the parser.
optparse.parse!

# Determines the instruction to present to the user; dependent on flags
if options[:utc] == true 
	t = "UTC" 
elsif options[:tz] == "" 
	t = "local" 
else
	t = options[:tz]
end

# Validate the user input and create a new DateTime object
treg = /\s?(([0-2]?[0-9]:[0-5][0-9]\s*)-(\s*[0-2]?[0-9]:[0-5][0-9]))/
range = false
if ARGV.any?{ |s| s.casecmp("now") == 0 }
	dt = Time.new
	year = dt.year
	month = dt.month
	day = dt.day
	hour = dt.hour
	minute = dt.min

elsif ARGV.join(" ").match(treg) # If a time range is detected; e.g. 13:00 - 14:00
	range = true
	tt = ARGV.join(" ")
	begin
		if ! tt.gsub(treg, '').empty? 
			date = DateTime.parse(tt.gsub(treg, ''))
		else 
			date = Time.new
		end
	rescue
		msg = "Error: There is a problem with the date you provided."
		puts msg
	end
	year = date.year
	month = date.month
	day = date.day
	begin
		tstart = DateTime.parse(tt.match(treg)[2].strip)
		tend = DateTime.parse(tt.match(treg)[3].strip)
	rescue
		msg = "Error: There is a problem with the time you provided."
		puts msg
	end
		tshour = tstart.hour
		tsmin = tstart.min
		tehour = tend.hour
		temin = tend.min
else
	begin
		dt = DateTime.parse(ARGV.join(" "))
	rescue
		msg = "Error: There is a problem with the date and/or time you provided."
		puts msg
		exit
	end
	# Generate the time variables 
	year = dt.year
	month = dt.month
	day = dt.day
	hour = dt.hour
	minute = dt.min
end

# Do the time conversion
if options[:utc] == false then
	if options[:tz] == "" then
		if range == true
			tstartLocal = Time.local(year, month, day, tshour, tsmin)
			tendLocal = Time.local(year, month, day, tehour, temin)
			puts tstartLocal.getgm.to_s + " - " + tendLocal.getgm.to_s
		else
			myTime = Time.local(year, month, day, hour, minute)
			puts myTime.getgm
		end
	else
		with_time_zone(options[:tz]) {
			if range == true
				tstartLocal = Time.local(year, month, day, tshour, tsmin)
				tendLocal = Time.local(year, month, day, tehour, temin)
				puts tstartLocal.getgm.to_s + " - " + tendLocal.getgm.to_s
			else
				myTime = Time.local(year, month, day, hour, minute)
				puts myTime.getgm
			end
		}
	end
else
	if options[:tz] == "" then
		if range == true
			tstartutc = Time.utc(year, month, day, tshour, tsmin)
			tendutc = Time.utc(year, month, day, tehour, temin)	
			puts tstartutc.getlocal.to_s + " - " + tendutc.getlocal.to_s
		else
			myTime = Time.utc(year, month, day, hour, minute)
			puts myTime.getlocal
		end
	else
		with_time_zone(options[:tz]) {
			if range == true
				tstartutc = Time.utc(year, month, day, tshour, tsmin)
				tendutc = Time.utc(year, month, day, tehour, temin)	
				puts tstartutc.getlocal.to_s + " - " + etime
			else
				myTime = Time.utc(year, month, day, hour, minute)
				puts myTime.getlocal
			end
		}
	end
end
