require_relative 'test_helper'

describe "Guidedown's command line interface" do
  it "converts indented code blocks to fenced code blocks" do
    assert_equal "This is a paragraph.\n\n```\ndef foo\n  puts 'bar'\nend\n```\n",
      `bin/guidedown examples/code_block.md`
  end

  it "sets language identifiers for code blocks with filenames" do
    assert_equal "``` ruby\n# example.rb\ndef foo\n  puts 'bar'\nend\n```\n",
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
end
