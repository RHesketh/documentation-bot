class MarkdownToSlack
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