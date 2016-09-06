require 'spec_helper'

describe MarkdownToSlack do
	let(:converter) { MarkdownToSlack.new }

	describe "#convert" do
		it "returns en empty string when given an nil" do 
			expect(converter.convert(nil)).to eq ""
		end

		it "accepts a string and returns back that same string" do 
			expect(converter.convert("Test1234")).to eq "Test1234"
		end

		it "takes a header and converts it to bold text" do
			test_string 	= "hello this is some nonsense\n# This line is a header!\nand now back to the nonsense"
			expected_string = "hello this is some nonsense\n*This line is a header!*\nand now back to the nonsense"

			expect(converter.convert(test_string)).to eq expected_string
		end

		it "takes subheaders and converts them to bold text" do
			test_string 	= "hello this is some nonsense\n## This line is a subheader!\nand now back to the nonsense"
			expected_string = "hello this is some nonsense\n*This line is a subheader!*\nand now back to the nonsense"

			expect(converter.convert(test_string)).to eq expected_string
		end
	end
end