# Internal: Converts the contents of a String containing Markdown into a format
# suitable for output into a Slack channel.
class MarkdownToSlack
	# Internal: Reformats some Markdown elements into a Slack equivalent.
	# Headers and subheaders will be converted into bold text, horizontal
	# rules are converted into a long line of dashes. 
	#
	# Long lists of methods outputted by `ri` are condensed into a 
	# comma-seperated list. Lists of class methods are considered to always 
	# have the following format (newlines explicitly shown for clarity):
	#   "Class methods:\n  (or "Instance methods:"])
	#   \n
	#       [method]\n
	#		[method]\n
	#   \n"
	#
	# input - A String containing the Markdown to be reformatted.
	#
	# Examples
	#
	#   convert("# Here is a header")
	#   # => "*Here is a header*"
	#
	#   convert("### Here is a subheader")
	#   # => "*Here is a subheader*"
	#
	# 	convert("Class methods:\n\n    count\n    new\n    reset\n\n")
	#   # => "Class methods:\ncount, new, reset\n\n"
	#
	# Returns a String containing the modified text.
	def convert(input)
		output = input.to_s.lines.map do |line|
			modified_line = line
			modified_line = wrap_in_bold modified_line if line_is_a_header? line
			modified_line = large_slack_line if line_is_a_horizontal_rule? line

			modified_line
		end

		output = condense_method_list(output, "Class methods:")
		output = condense_method_list(output, "Instance methods:")

		return output.join
	end

	private

	def condense_method_list(output, header)
		header_index = output.find_index{|l| l.downcase.include?("#{header.downcase}")}
		return output if header_index.nil?
		first_newline_index = output[header_index..-1].find_index{|l| l =~/^\n$/} + header_index
		second_newline_index = output[first_newline_index+1..-1].find_index{|l| l =~/^\n$/} + first_newline_index+1
		return outpit if first_newline_index.nil? || second_newline_index.nil?

		joined_methods = output[first_newline_index+1..second_newline_index-1].map{|m| m.strip}.join(", ")
		return output[0..header_index] + [joined_methods, "\n"] + output[second_newline_index..-1]
	end

	def remove_markdown_header(input)
		return input.scan(/^\#{1,6} (.+)$/).flatten.first
	end

	def wrap_in_bold(input)
		output = remove_markdown_header(input)
		return "*#{output}*\n"
	end

	def large_slack_line
		"~--------------------------------------------------------------------------------~\n"
	end

	def line_is_a_header?(line)
		return line.scan(/^\#{1,6} .+$/).count > 0
	end

	def line_is_a_horizontal_rule?(line)
		return line.scan(/^---$/).count > 0
	end
end