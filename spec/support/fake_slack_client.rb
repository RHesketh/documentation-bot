require 'spec_helper'
# explain in TomDoc that this class allows us to test the .on callbacks
class FakeSlackClient
	attr_reader :sent_messages

	def initialize(options={})
		@events = {}
		@sent_messages = []
		@name 			= options[:name] 		|| "Fake Slack User"
		@team_name 		= options[:team_name]	|| "Fake Slack Team"
		@domain 		= options[:domain]		|| "fake"
		@id				= options[:domain]		|| "UABC12345"
	end

	def execute(event, params = nil)
		@events[event].call(params)
	end

	# Fake methods and attributes
	def on(event, &block)
		@events[event] = block
	end

	def start!
	end

	def message(options)
		@sent_messages << options[:text]
	end

	def team
		@team ||= OpenStruct.new(:name => @team_name, :domain => @domain)
	end

	def self
		@self ||= OpenStruct.new(:name => @name, :id => @id)
	end

	def channels
		{
			"DUMMYDUMMY1" => {
				"name" => "xyztestxyz", "is_member"=>true
			}
		}
	end
end