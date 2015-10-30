require_relative 'test_helper'

describe "Guidedown's command line interface" do
  it "uses file contents" do
    assert_equal "This is a paragraph.\n",
      `bin/guidedown examples/paragraph.md`
  end

  it "uses piped strings" do
    assert_equal "This is a paragraph.\n",
      `echo "This is a paragraph." | bin/guidedown`
  end

  it "converts indented code blocks to fenced code blocks" do
    assert_equal "This is a paragraph.\n\n```\ndef foo\n  puts 'bar'\nend\n```\n",
      `bin/guidedown examples/code_block.md`
  end

  it "sets language identifiers for code blocks with filenames" do
    assert_equal "``` ruby\n# examples/example.rb\ndef foo\n  puts 'bar'\nend\n```\n",
      `bin/guidedown examples/syntax_highlighting.md`
  end

  it "sets the code block's info string using the comment line" do
    assert_equal "``` ruby\ndef foo\n  puts 'bar'\nend\n```\n",
      `bin/guidedown examples/syntax_highlighting_comment.md`
  end

  it "replaces code blocks with actual file contents" do
    assert_equal "``` ruby\n# examples/example.rb\ndef foo\n  puts 'bar'\nend\n```\n",
      `bin/guidedown examples/code_block_replacement.md`
  end

  it "replaces code blocks with single lines from actual files" do
    assert_equal "``` ruby\n# examples/example.rb:2\n  puts 'bar'\n```\n",
      `bin/guidedown examples/code_block_replacement_single_line.md`
  end

  it "replaces code blocks with line ranges from actual files" do
    assert_equal "``` ruby\n# examples/example.rb:1-2\ndef foo\n  puts 'bar'\n```\n",
      `bin/guidedown examples/code_block_replacement_line_range.md`
  end

  it "replaces code blocks with file contents, but omits a part" do
    assert_equal "``` ruby\n# examples/example.rb\ndef foo\n  ...\nend\n```\n",
      `bin/guidedown examples/code_block_replacement_ellipsis.md`
  end

  it "replaces code blocks with command line output" do
    assert_equal "``` console\n$ echo 'foo'\nfoo\n```\n",
      `bin/guidedown examples/code_block_replacement_console_output.md`
  end

  it "replaces code blocks with command line output with a hidden command" do
    assert_equal "``` console\nfoo\n```\n",
      `bin/guidedown examples/code_block_replacement_console_output_hidden_command.md`
  end

  it "does not replace code blocks with only a console command" do
    assert_equal "``` console\n$ gem install guidedown\n```\n",
      `bin/guidedown examples/code_block_replacement_command_without_output.md`
  end

  describe "command line options" do
    it "shows the help message" do
      assert_equal "Usage: guidedown [options]\n",
        `bin/guidedown -h`.lines.first
    end

    it "uses HTML code blocks" do
      assert_equal "This is a paragraph.\n\n<pre><code>def foo\n  puts 'bar'\nend\n</code></pre>\n",
        `bin/guidedown examples/code_block.md --html-code-blocks`
    end
  end
end
