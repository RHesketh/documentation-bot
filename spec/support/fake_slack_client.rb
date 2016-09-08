require 'spec_helper'

# Internal: A fake Slack client to be used as a dummy in order to avoid making
# calls to the real Slack API during testing. Event callbacks passed to the 
# real client can be stored and executed later. Outgoing messages can also
# be recorded for later verification.
class FakeSlackClient
	# Internal: Returns an Array of Strings containing outgoing messages.
	attr_reader :sent_messages

	# Internal: Creates a new fake Slack client.
	#
	# options - Settings related to the bot's identity (Default: {})
	#           :name      - The fake user's Slack username (optional).
	#           :id        - The fake user's internal Slack ID (optional).
	#           :team_name - The fake Slack team's name (optional).
	#           :domain	   - The fake Slack team's domain (optional).
	def initialize(options={})
		@events = {}
		@sent_messages = []
		@name 			= options[:name] 		|| "Fake Slack User"
		@team_name 		= options[:team_name]	|| "Fake Slack Team"
		@domain 		= options[:domain]		|| "fake"
		@id				= options[:id]		    || "UABC12345"
	end

	# Internal: Mimics a call to the Slack client's event handler, storing
	# the passed execution block for use later.
	#
	# event - The Symbol name of the event being hooked.
	# block - The block that is intended to be executed when the event fires.
	#
	# Examples
	#   on :message, { @output.puts "We received a message!"}
	#
	# Returns nothing.
	def on(event, &block)
		@events[event] = block
	end

	# Internal: Executes an event block that was stored earlier using #on.
	#
	# event - The original Symbol name of the event stored using #on.
	# params - Params that will be passed to the executed block (Default: nil).
	def execute(event, params = nil)
		@events[event].call(params)
	end

	# Internal: Mimics the Slack client's method for sending a message. The
	# text of any message "sent" using this method is stored and can be read
	# using #sent_messages.
	# 
	# options - The options hash that would be passed to the Slack client.
	def message(options)
		@sent_messages << options[:text]
	end

	# Internal: Mimics the call to the Slack client for team information.
	#
	# Returns a struct that answers calls to .name and .domain
	def team
		@team ||= OpenStruct.new(:name => @team_name, :domain => @domain)
	end

	# Internal: Mimics the call to the Slack client for user information.
	#
	# Returns a struct that answers calls to .name and .id
	def self
		@self ||= OpenStruct.new(:name => @name, :id => @id)
	end

	# Internal: Mimics the call to the Slack client for channels information.
	#
	# Returns a Hash that mimics the Slack client's channel information.
	def channels
		{
			"CDUMMYDUMMY1" => {
				"name" => "xyztestxyz", "is_member"=>true
			}
		}
	end

	# Internal: Swallows a call to the Slack client's .start! 
	def start!
	end
end