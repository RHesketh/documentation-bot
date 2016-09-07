require 'spec_helper'
require 'support/fake_slack_client'

describe "Bot responds to a help request" do
	let(:fake_slack) { FakeSlackClient.new }
	let(:slack_api_token) { "DUMMY-12345-dummy-67890-DMY" }
	let(:doc_bot) {DocumentationBot.new(slack_api_token, {slack_client: fake_slack})}

	before(:each) do
		doc_bot.start!
	end

	it "with basic info about the bot" do
		message = {"channel"=>"DDUMMYDUMMY1", "user"=>"FAKEFAKE1", "text"=>"help"}

		fake_slack.execute(:message, message)
		expect(fake_slack.sent_messages.first.include?(fake_slack.self.name)).to eq true
	end
end