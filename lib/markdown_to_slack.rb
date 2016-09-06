class MarkdownToSlack
	def convert(input)
		output = input.to_s.lines.map do |line|
			modified_line = line
			modified_line = wrap_in_bold modified_line if line_is_a_header? line

			modified_line
		end

		return output.join
	end

	private

	def remove_markdown_header(input)
		return input.scan(/^\#{1,6} (.+)$/).flatten.first
	end

	def wrap_in_bold(input)
		output = remove_markdown_header(input)
		return "*#{output}*\n"
	end

	def line_is_a_header?(line)
		return line.scan(/^\#{1,6} .+$/).count > 0
	end
end