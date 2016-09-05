require 'spec_helper'
# explain in TomDoc that this class allows us to test the .on callbacks
class FakeSlackClient
	# Test housekeeping stuff
	def initialize
		@events = {}
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

	def team
		@team ||= OpenStruct.new(:name => "Fake Slack Team", :domain => "fake")
	end

	def self
		@self ||= OpenStruct.new(:name => "Fake Slack Client")
	end

	def channels
		{
			"DUMMYDUMMY1" => {
				"name" => "xyztestxyz", "is_member"=>true
			}
		}
	end
end