require 'spec_helper'
require 'support/fake_slack_client'

describe "Bot responds to a request for documentation" do
	let(:fake_slack) { FakeSlackClient.new }
	let(:slack_api_token) { "DUMMY-12345-dummy-67890-DMY" }
	let(:doc_bot) {DocumentationBot.new(slack_api_token, {slack_client: fake_slack})}

	before(:each) do
		doc_bot.start!
	end

	it "with the right entry if asked for something in the ri docs" do
		message = {"channel"=>"DDUMMYDUMMY1", "user"=>"FAKEFAKE1", "text"=>"Array"}

		fake_slack.execute(:message, message)
		expect(fake_slack.sent_messages.first.include?("Array < Object")).to eq true
	end

	it "with an apology if it cannot find something" do 
		message = {"channel"=>"DDUMMYDUMMY1", "user"=>"FAKEFAKE1", "text"=>"Test1234"}

		fake_slack.execute(:message, message)
		expect(fake_slack.sent_messages.first.include?("Sorry")).to eq true
	end
end