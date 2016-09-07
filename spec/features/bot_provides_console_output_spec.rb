require 'spec_helper'
require 'stringio'
require 'support/fake_slack_client'

describe "Bot provides console output" do
	let(:output) {StringIO.new}
	let(:slack_api_token) { "DUMMY-12345-dummy-67890-DMY" }
	let(:fake_slack) { FakeSlackClient.new }
	let(:doc_bot) {DocumentationBot.new(slack_api_token, {output: output, slack_client: fake_slack})}

	before(:each) do
		doc_bot.start!
	end

	it 'Announces that it has connected to a slack team' do	
		fake_slack.execute(:hello)
		expect(output.string.include?("Successfully connected")).to be true
	end

	it 'Announces that it has joined a slack channel' do	
		fake_join_event = {"channel" => {"name" => "test1234"}}

		fake_slack.execute(:channel_joined, fake_join_event)
		expect(output.string.include?("joined channel")).to be true
		expect(output.string.include?("test1234")).to be true
	end

	it 'Announces that it has left a slack channel' do	
		fake_leave_event = OpenStruct.new(:channel => "DUMMYDUMMY1")
		fake_slack.execute(:channel_left, fake_leave_event)
		
		expect(output.string.include?("left channel")).to be true
		expect(output.string.include?("xyztestxyz")).to be true
	end
end