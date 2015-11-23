require_relative 'test_helper'
examples_path = File.expand_path(File.dirname(__FILE__) + '/../examples')

describe Guidedown do
  before do
    Dir.chdir(examples_path)
  end

  it "converts indented code blocks to fenced code blocks" do
    assert_equal "```\nfoo\n```\n", Guidedown.new("    foo\n").to_s
  end

  it "converts indented multiline code blocks to fenced code blocks" do
    assert_equal "```\nfoo\nbar\n```\n", Guidedown.new("    foo\n    bar\n").to_s
  end

  it "does not include paragraphs in the code blocks" do
    assert_equal "Paragraph.\n\n```\nfoo\n```\n",
      Guidedown.new("Paragraph.\n\n    foo\n").to_s
  end

  it "does not remove more than four spaces from code blocks" do
    assert_equal "```\n    foo\n```\n",
      Guidedown.new("        foo\n").to_s
  end

  it "sets the language identifier for a code block" do
    assert_equal "``` ruby\n# example.rb\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
      Guidedown.new("    # example.rb\n    class Foo\n      def foo\n        puts 'bar'\n      end\n    end\n").to_s
  end

  it "sets the language identifier from the code block comment line" do
    assert_equal "``` ruby\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
      Guidedown.new("    # ruby\n    class Foo\n      def foo\n        puts 'bar'\n      end\n    end\n").to_s
  end

  it "replaces code blocks with actual file contents" do
    assert_equal "``` ruby\n# example.rb\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
      Guidedown.new("    # example.rb\n    class Foo\n      def foo\n        # TODO: replace this...\n      end\n    end\n").to_s
  end

  it "takes a single line from the file" do
    assert_equal "``` ruby\n# example.rb:3\n    puts 'bar'\n```\n",
      Guidedown.new("    # example.rb:3\n      # TODO: replace this...\n").to_s
  end

  it "takes a line range from the file" do
    assert_equal "``` ruby\n# example.rb:1-2\nclass Foo\n  def foo\n```\n",
      Guidedown.new("    # example.rb:1-2\n    class Foo\n      def foo\n").to_s
  end

  it "replaces code blocks with file contents with ommitted parts" do
    assert_equal "``` ruby\n# example.rb\nclass Foo\n  ...\nend\n```\n",
      Guidedown.new("    # example.rb\n    class Foo\n      ...\n    end\n").to_s
  end

  describe "with a specific revision of a file" do
    it "replaces code blocks with actual file contents" do
      assert_equal "``` ruby\n# example.rb\n# TODO: Write an example\n```\n",
        Guidedown.new("    # example.rb @ 106bbc\n      # TODO: replace this...\n").to_s
    end
  end

  it "replaces code blocks with command line output" do
    assert_equal "``` console\n$ echo foo\nfoo\n```\n",
      Guidedown.new("    $ echo foo\n    bar?\n").to_s
  end

  it "replaces code blocks with command line output in a specific revision" do
    assert_equal "``` console\n$ ls\nexample.rb\n```\n",
      Guidedown.new("    $ ls @ 106bbc\n    example.ex\n").to_s
  end

  it "replaces code blocks with command line output with a hidden command" do
    assert_equal "``` console\nfoo\n```\n",
      Guidedown.new("    # $ echo foo\n    bar?\n").to_s
  end

  it "does not replace code blocks with only a console command" do
    assert_equal "``` console\n$ echo foo\n```\n",
      Guidedown.new("    $ echo foo\n").to_s
  end

  it "wraps code blocks in <pre> and <code> tags instead of backticks" do
    assert_equal "<pre><code>foo\n</code></pre>\n", Guidedown.new("    foo\n", html_code_blocks: true).to_s
  end

  it "omits filenames" do
    assert_equal "``` ruby\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
      Guidedown.new("    # example.rb\n", no_filenames: true).to_s
  end

  it "removes leading spaces from info strings" do
    assert_equal "```ruby\n# example.rb\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
      Guidedown.new("    # example.rb\n", sticky_info_strings: true).to_s
  end
end
