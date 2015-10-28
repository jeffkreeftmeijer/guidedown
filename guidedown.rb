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
      output << "\n#{comment_line}" unless info_string == comment_line_contents
      output << "\n#{unindented_data}"

      "```#{output.join}```"
    end

    def name
      split_comment_line_contents.first || ''
    end

    def language_name
      language.name.downcase if language
    end

    def info_string
      language_name || comment_line_contents
    end

    def unindented_data
      if file
        data = [file.lines[line_numbers]]
      else
        data = comment_line ? lines[1..-1] : lines
      end

      data.join.gsub(/^ {4}/, '')
    end

    private

    def file
      File.read(name) if File.exists?(name)
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

    def split_comment_line_contents
      if comment_line_contents
        comment_line_contents.split(':')
      else
        []
      end
    end

    def line_numbers?
      split_comment_line_contents.length > 1
    end

    def split_line_numbers
      split_comment_line_contents.last.split('-')
    end

    def line_numbers
      if line_numbers?
        (split_line_numbers.first.to_i - 1)..(split_line_numbers.last.to_i - 1)
      else
        0..-1
      end
    end
  end

  class Formatter
    ELLIPSIS_PATTERN = /^\s*\.{3,}/

    def initialize(pattern)
      @pattern = pattern
      @head, @tail = @pattern.split(ELLIPSIS_PATTERN)
    end

    def format(input)
      if ellipsis?
        output = []
        output << input.lines[head_range] if head?
        output << "#{ellipsis}\n"
        output << input.lines[tail_range] if tail?
        output.join
      else
        input
      end
    end

    private

    def ellipsis
      @pattern.match(ELLIPSIS_PATTERN).to_s
    end

    def ellipsis?
      !ellipsis.empty?
    end

    def head_range
      0..@head.lines.count - 1
    end

    def tail_range
      - @tail.lines.count + 1..-1
    end

    def head?
      @head && !@head.empty?
    end

    def tail?
      @tail && !@tail.empty?
    end
  end
end
