class RiLookup
	def find(command)
		lookup_result = %x[ri #{command} --format=markdown]

		return nil if lookup_result.to_s.empty?
		return lookup_result
	end
end