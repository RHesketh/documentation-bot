require 'spec_helper'

describe MarkdownToSlack do
  let(:converter) { MarkdownToSlack.new }

  describe "#convert" do
    it "returns en empty string when given a nil" do 
      expect(converter.convert(nil)).to eq ""
    end

    it "accepts a string and returns back that same string" do 
      expect(converter.convert("Test1234")).to eq "Test1234"
    end

    it "takes a header and converts it to bold text" do
      test_string   = "hello this is some nonsense\n# This line is a header!\nand now back to the nonsense"
      expected_string = "hello this is some nonsense\n*This line is a header!*\nand now back to the nonsense"

      expect(converter.convert(test_string)).to eq expected_string
    end

    it "takes subheaders and converts them to bold text" do
      test_string   = "hello this is some nonsense\n## This line is a subheader!\nand now back to the nonsense"
      expected_string = "hello this is some nonsense\n*This line is a subheader!*\nand now back to the nonsense"

      expect(converter.convert(test_string)).to eq expected_string
    end

    it "cleans up the display of class methods" do
      test_string   = "hello this is some nonsense\n# Class methods:\n\n    a method\n    another method\n\nand now back to the nonsense"
      expected_string = "hello this is some nonsense\n*Class methods:*\na method, another method\n\nand now back to the nonsense"

      expect(converter.convert(test_string)).to eq expected_string
    end

    it "cleans up the display of instance methods" do
      test_string   = "hello this is some nonsense\n# Instance methods:\n\n    a method\n    another method\n\nand now back to the nonsense"
      expected_string = "hello this is some nonsense\n*Instance methods:*\na method, another method\n\nand now back to the nonsense"

      expect(converter.convert(test_string)).to eq expected_string
    end

    it "makes horizontal rules more visible" do
      test_string   = "hello this is some nonsense\n---\nand now back to the nonsense"
      expected_string = "hello this is some nonsense\n~--------------------------------------------------------------------------------~\nand now back to the nonsense"

      expect(converter.convert(test_string)).to eq expected_string
    end
  end
end