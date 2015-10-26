require 'minitest/autorun'

describe "Guidedown's command line interface" do
  it "converts indented code blocks to fenced code blocks" do
    assert_equal "This is a paragraph.\n\n```\ndef foo\n  puts 'bar'\nend\n```\n",
      `bin/guidedown examples/code_block.md`
  end
end