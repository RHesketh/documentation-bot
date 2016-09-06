require 'spec_helper'

describe RiLookup do
	let(:ri_lookup) { RiLookup.new }
	describe "#find" do
		it "returns description when the documentation is found" do 
			expect(ri_lookup.find("Array")).to be_a String
			expect(ri_lookup.find("Array").include?("Array < Object")).to eq true
		end

		it "returns nil if the documentation was not found" do 
			expect(ri_lookup.find("NotFound")).to eq nil
		end 
	end
end