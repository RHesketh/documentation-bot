require 'slack-ruby-client'

class DocumentationBot
	def initialize(slack_api_token)
		raise ArgumentError.new("A Slack API token must be specified as the first parameter") if slack_api_token.to_s.empty?

		# Configures the ENV token globally
		Slack.configure do |config|
		  config.token = slack_api_token
		end
	end	

	def start!(options = {})
		@client = options[:slack_client] || Slack::RealTime::Client.new
		@client.auth_test if options[:test_authentication]
	end
end