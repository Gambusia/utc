# The utc Facility
## Introduction
The utc facility is a simple tool to convert back and forth between Canadian time zones and Universal Coordinated Time (UTC), which is the same everywhere in the world for any given moment. The motivation for this tool was that I was having to set meeting times with people across Canada, many of whom lived in different time zones. This task became confusing, especially when trying to coordinate times for people in different time zones both west and east of me. Eventually, a colleague and I started coordinating our meetings on the basis of UTC, which was the same for both of us despite being in different time zones. This strategy turned out to be incredibly useful and whole lot less confusing, so I started using UTC for all sorts of things. 

The only problem with using UTC is that it's not always immediately intuitive how to convert from some time zone to UTC, especially when some time zones observe Daylight Savings Time and others don't. Often, I would need to do the conversion using some Internet tool, which wasn't aways convenient. This is why I wrote this little command line program. 

Although it would be more broadly applicable if it included all time zones world-wide, this program is limited to only Canadian time zones, because those are the time zones I work with most. Maybe in a future update I'll get around to including all time zones. 

## Installation
Unzip the archive to wherever you want and just run the program from there. It can live anywhere in your file hierarchy and will work just fine. As long as you've got a Ruby runtime environment installed on your system, you can run the program right out of the box using standard Ruby conventions. For example, navigate to the utc directory and type:

	ruby utc.rb now 

to display the current time in UTC. This approach will work with all options, including presenting a user manual using the -m flag. You can confirm whether or not you have a Ruby runtime environment by simply issuing `ruby -v` on the command line to get the version of Ruby you're currently running. If you don't have a Ruby runtime environment, please download one [*here*](https://www.ruby-lang.org/en/documentation/installation/).

For simpler use, add an alias to your shell profile, and restart your shell.

	alias utc="ruby /path/to/utc/utc.rb" 

Adding the alias will allow you to simply type `utc` on the command line to make use of the tool, without having to call ruby or navigate to the directory containing the program.

## Getting Started
Once you have the tool up and running, simply type `utc -m` (or `ruby utc.rb -m` from within the utc directory if you didn't add the alias to your profile configuration file). This will pull up a short user manual with all the details you need to use the facility.

Thanks for downloading this little tool. I hope you find it useful.

