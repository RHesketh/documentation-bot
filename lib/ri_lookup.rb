class RiLookup
	def find(command)
		command = strip_weird_characters(command)
		lookup_result = %x[ri #{command} --format=markdown]

		return nil if lookup_result.to_s.empty?
		return lookup_result
	end

	private

	def strip_weird_characters(input)
		return input.gsub(/[^A-Za-z\d:_.!]/, "")
	end
end