# Internal: Look up documentation using the `ri` command line tool.
class RiLookup
	# Internal: Search for documentation relating to a specific class or method.
	# This is achieved by making a command line call to `ri` and returning the
	# output. 
	#
	# command - A String containing the name of the class or method that you
	#           are looking up documentation for. Non-alphanumeric characters
	#           other than ':', '.', '!' and '#' will be ignored. 
	#
	# Examples
	#
	#   find("Array")
	#   # => "# File < IO\n\n(from ruby site)\n---\nA File is an abstraction ..."
	#
	# Returns Markdown from `ri` as a String or nil if nothing was found.
	def find(command)
		command = strip_weird_characters(command)
		lookup_result = %x[ri #{command} --format=markdown]

		return nil if lookup_result.to_s.empty?
		return lookup_result
	end

	private

	def strip_weird_characters(input)
		return input.gsub(/[^A-Za-z\d:_.!#]/, "")
	end
end