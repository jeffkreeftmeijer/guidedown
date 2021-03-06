require 'linguist'
require 'git_run'

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
      command_line.to_s if command_line && !command_line.hidden?
    end

    def contents
      data = case
      when comment_line && comment_line.revision || file
        formatter = Formatter.new(data_without_comments_or_commands)

        if comment_line.revision
          contents = `git show #{revision}:#{name}`
          formatter.format(contents.lines[comment_line.line_number_range].join)
        else
          formatter.format(file.lines[comment_line.line_number_range].join)
        end
      when command_line
        return '' if data_without_comments_or_commands.empty?
        if revision = command_line.revision
          GitRun.run(revision, command_line.command)
        else
          `#{command_line.command}`
        end
      else
        data_without_comments_or_commands.gsub(/^ {4}/, '')
      end
    end

    private

    def lines
      @data.lines
    end

    def comment_line
      if match = lines.first.match(/# (.+)/)
        CommentLine.new(match)
      end
    end

    def data_without_comments_or_commands
      if comment_line || command_line
        lines[1..-1]
      else
        lines[0..-1]
      end.join
    end

    def command_line
      if match = lines.first.match(/(# )?\$ (.+)/)
        CommandLine.new(match)
      end
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
        @filename_with_line_numbers, @revision = @line.split(' @ ')
        @filename, @line_numbers = @filename_with_line_numbers.split(':')
      end

      def contents
        to_s.sub(/^# /, '')
      end

      def filename
        @filename.sub(/^# /, '')
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

    class CommandLine
      attr_reader :command, :revision

      def initialize(match)
        @line = match.to_s
        @command, @revision = @line.split(' @ ')
      end

      def command
        to_s.sub(/^(# )?\$ /, '')
      end

      def to_s
        @line.sub(/ @(.+)$/, '')
      end

      def hidden?
        to_s.match(/^#/)
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
