require_relative 'test_helper'
examples_path = File.expand_path(File.dirname(__FILE__) + '/../examples')

describe "Guidedown's command line interface" do
  before do 
    Dir.chdir(examples_path)
  end

  it "uses file contents" do
    assert_equal "This is a paragraph.\n",
      `../bin/guidedown paragraph.md`
  end

  it "uses piped strings" do
    assert_equal "This is a paragraph.\n",
      `echo "This is a paragraph." | ../bin/guidedown`
  end

  it "converts indented code blocks to fenced code blocks" do
    assert_equal "This is a paragraph.\n\n```\ndef foo\n  puts 'bar'\nend\n```\n\nThis is another paragraph.\n",
      `../bin/guidedown code_block.md`
  end

  it "sets language identifiers for code blocks with filenames" do
    assert_equal "``` ruby\n# example.rb\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
      `../bin/guidedown syntax_highlighting.md`
  end

  it "sets the code block's info string using the comment line" do
    assert_equal "``` ruby\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
      `../bin/guidedown syntax_highlighting_comment.md`
  end

  it "replaces code blocks with actual file contents" do
    assert_equal "``` ruby\n# example.rb\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
      `../bin/guidedown code_block_replacement.md`
  end

  it "replaces code blocks with a specific revision of a file" do
    assert_equal "``` ruby\n# example.rb\n# TODO: Write an example```\n",
      `../bin/guidedown code_block_replacement_revision.md`
  end

  it "replaces code blocks with single lines from actual files" do
    assert_equal "``` ruby\n# example.rb:3\n    puts 'bar'\n```\n",
      `../bin/guidedown code_block_replacement_single_line.md`
  end

  it "replaces code blocks with line ranges from actual files" do
    assert_equal "``` ruby\n# example.rb:2-4\n  def foo\n    puts 'bar'\n  end\n```\n",
      `../bin/guidedown code_block_replacement_line_range.md`
  end

  it "replaces code blocks with file contents, but omits a part" do
    assert_equal "``` ruby\n# example.rb\nclass Foo\n  ...\nend\n```\n",
      `../bin/guidedown code_block_replacement_ellipsis.md`
  end

  it "replaces code blocks with command line output" do
    assert_equal "``` console\n$ echo 'foo'\nfoo\n```\n",
      `../bin/guidedown code_block_replacement_console_output.md`
  end

  it "replaces code blocks with command line output in a specific revision" do
    assert_equal "``` console\n$ ls\nexample.rb\n```\n",
      `../bin/guidedown code_block_replacement_console_output_revision.md`
  end

  it "replaces code blocks with command line output with a hidden command" do
    assert_equal "``` console\nfoo\n```\n",
      `../bin/guidedown code_block_replacement_console_output_hidden_command.md`
  end

  it "does not replace code blocks with only a console command" do
    assert_equal "``` console\n$ gem install guidedown\n```\n",
      `../bin/guidedown code_block_replacement_command_without_output.md`
  end

  describe "command line options" do
    it "shows the help message" do
      assert_equal "Usage: guidedown [options]\n",
        `../bin/guidedown -h`.lines.first
    end

    it "uses HTML code blocks" do
      assert_equal "This is a paragraph.\n\n<pre><code>def foo\n  puts 'bar'\nend\n</code></pre>\n\nThis is another paragraph.\n",
        `../bin/guidedown code_block.md --html-code-blocks`
    end

    it "omits filenames" do
      assert_equal "``` ruby\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
        `../bin/guidedown code_block_replacement.md --no-filenames`
    end

    it "removes leading spaces from info strings" do
      assert_equal "```ruby\n# example.rb\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n",
        `../bin/guidedown code_block_replacement.md --sticky-info-strings`
    end
  end
end
