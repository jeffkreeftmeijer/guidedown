require 'linguist'

class Guidedown
  def initialize(input, options = {})
    @input = input
    @options = options
  end

  def to_s
    @input.gsub(/ {4,}.+(\n+ {4,}.+)*\n/).each do |match|
      Codeblock.new(match, @options).to_s
    end
  end

  class Codeblock
    include Linguist::BlobHelper
    attr_reader :data

    def initialize(data, options = {})
      @data = data
      @options = options
    end

    def to_s
      parts = []
      unless @options[:html_code_blocks]
        if @options[:sticky_info_strings]
          parts << info_string
        else
          parts << " #{info_string}".rstrip
        end
      end
      parts << comment unless @options[:no_filenames]
      parts << command
      parts << contents
      output = parts.compact.join("\n")

      if @options[:html_code_blocks]
        "<pre><code>#{output}</code></pre>\n"
      else
        "```#{output}```\n"
      end
    end

    def name
      comment_line ? comment_line.filename : ''
    end

    def language_name
      case
      when language
        language.name.downcase
      when command_line
        'console'
      end
    end

    def info_string
      if file || command_line || revision
        language_name
      else
        comment_line.contents if comment_line
      end
    end

    def comment
      comment_line.to_s if file
    end

    def command
      command_line.to_s if command_line && !hidden_command?
    end

    def contents
      data = case
      when revision
        formatter = Formatter.new(data_without_comments_or_commands)
        contents = `git show #{revision}:#{name}`
        formatter.format(contents.lines[comment_line.line_number_range].join)
      when file
        formatter = Formatter.new(data_without_comments_or_commands)
        formatter.format(file.lines[comment_line.line_number_range].join)
      when executable_command
        data_without_comments_or_commands.empty? ? '' : `#{executable_command}`
      else
        data_without_comments_or_commands.gsub(/^ {4}/, '')
      end
    end

    private

    def lines
      @data.lines
    end

    def comment_line
      if !hidden_command? && match = lines.first.match(/# (.+)/)
        CommentLine.new(match)
      end
    end

    def data_without_comments_or_commands
      (lines[[!!comment_line, !!command_line].count(true)..-1] || []).join
    end

    def command_line
      lines.first.match(/(# )?\$ (.+)/)
    end

    def executable_command
      if command_line
        command_line.to_s.sub(/^(# )?\$ /, '')
      end
    end

    def hidden_command?
      command_line.to_s.match(/^# \$/)
    end

    def file
      File.read(name) if File.exists?(name)
    end

    def revision
      comment_line.revision if comment_line
    end

    class CommentLine
      attr_reader :filename, :revision

      def initialize(match)
        @line = match.to_s
        @filename, @line_numbers, @revision =
          @line.match(/(?:#|\$) ([^: ]+):?([0-9-]+)?(?: \@ )?(.+)?/).captures
      end

      def type
        case @line
        when /^\$/
          :command
        when /^#/
          :filename
        end
      end

      def contents
        to_s.sub(/^# /, '')
      end

      def to_s
        @line.sub(/ @(.+)$/, '')
      end

      def line_number_range
        if @line_numbers
          split_line_numbers = @line_numbers.split('-')
          (split_line_numbers.first.to_i - 1)..(split_line_numbers.last.to_i - 1)
        else
          0..-1
        end
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
      @pattern.match(ELLIPSIS_PATTERN).to_s.gsub(/^ {4}/, '')
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
