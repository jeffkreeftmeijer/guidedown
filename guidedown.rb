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

    def name
      comment_line_contents.to_s
    end

    def to_s
      if info_string
        "``` #{info_string}\n#{unindented_data}```"
      else
        "```\n#{unindented_data}```"
      end
    end

    def unindented_data
      @data.gsub(/^ {4}/, '')
    end

    def comment_line
      @data.lines.first.match(/# (.+)/)
    end

    def comment_line_contents
      if comment_line
        comment_line.to_s.sub(/^# /, '')
      end
    end

    def language_name
      language.name.downcase if language
    end

    def info_string
      language_name || comment_line_contents
    end
  end
end
