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
      output = [
        " #{info_string}".rstrip,
        comment,
        unindented_data
      ]

      "```#{output.compact.join("\n")}```"
    end

    def name
      split_comment_line_contents.first || ''
    end

    def language_name
      case
      when language
        language.name.downcase
      when command
        'console'
      end
    end

    def info_string
      file || command ? language_name : comment_line_contents
    end

    def comment
      comment_line.to_s if file
    end

    def unindented_data
      data = case
      when file
        Formatter.new(data_without_comment_line).format(file.lines[line_numbers].join)
      when command
        output = []
        output << command_line unless hidden_command?
        output << `#{command}`

        output.join("\n")
      else
        data_without_comment_line
      end

      data.gsub(/^ {4}/, '')
    end

    private

    def data_without_comment_line
      (comment_line ? lines[1..-1] : lines).join
    end

    def file
      File.read(name) if File.exists?(name)
    end

    def command
      if command_line
        command_line.to_s.sub(/^(# )?\$ /, '')
      end
    end

    def hidden_command?
      command_line.to_s.match(/^# \$/)
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

    def command_line
      lines.first.match(/(# )?\$ (.+)/)
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
