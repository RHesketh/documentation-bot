class DocumentationBot
	def initialize(slack_api_token)
		raise ArgumentError("A Slack API token must be specified as the first parameter") if slack_api_token.empty?

		@slack_api_token = slack_api_token
	end	
end