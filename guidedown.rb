require 'linguist'

class Guidedown
  def initialize(input)
    @input = input
  end

  def to_s
    @input.gsub(/ {4,}.+(\n+ {4,}.+)*\n/).each do |match|
      Codeblock.new(match).to_s
    end
  end

  class Codeblock
    include Linguist::BlobHelper
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_s
      output = []
      output << " #{info_string}" if info_string
      output << "\n#{unindented_data}"

      "```#{output.join}```"
    end

    def name
      comment_line_contents.to_s
    end

    def language_name
      language.name.downcase if language
    end

    def info_string
      language_name || comment_line_contents
    end

    private

    def unindented_data
      @data.gsub(/^ {4}/, '')
    end

    def lines
      @data.lines
    end

    def comment_line
      lines.first.match(/# (.+)/)
    end

    def comment_line_contents
      if comment_line
        comment_line.to_s.sub(/^# /, '')
      end
    end
  end
end
