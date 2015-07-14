#!/usr/bin/env ruby

#Pulled in lines 9-17 from [misterpaul] https://github.com/misterpaul/NexposeRubyScripts/blob/master/ScanPlanReporter/ScanPlanReporter.rb
require 'nexpose'
require 'time'
require 'highline/import'
include Nexpose

# Defaults: Change to suit your environment.
default_host = 'your-host'
default_port = 3780
default_name = 'your-nexpose-id'

host = ask('Enter the server name (host) for Nexpose: ') { |q| q.default = default_host }
port = ask('Enter the port for Nexpose: ') { |q| q.default = default_port.to_s }
user = ask('Enter your username: ') { |q| q.default = default_name }
pass = ask('Enter your password: ') { |q| q.echo = '*' }

begin
nsc = Connection.new(host, user, pass, port)
nsc.login

	
rescue ::Nexpose::APIError => e
	$stderr.puts ("Connection failed: #{e.reason}")
	exit(1)
end

#
# Query a list of all NeXpose sites and display them
#
sites = nsc.list_sites || []
case sites.length
when 0
	puts("There are currently no active sites on this NeXpose instance")
else

sites.each do |site|
        puts ("Site ID: #{site.id},Site Name: #{site.name},Risk Score: #{site.risk_score}")
end
end

nsc.logout

