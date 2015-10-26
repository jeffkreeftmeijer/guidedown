require 'minitest/autorun'
require_relative 'guidedown'

describe Guidedown do
  it "converts indented code blocks to fenced code blocks" do
    assert_equal "```\nfoo\n```", Guidedown.new("    foo\n").to_s
  end

  it "converts indented multiline code blocks to fenced code blocks" do
    assert_equal "```\nfoo\nbar\n```", Guidedown.new("    foo\n    bar\n").to_s
  end

  it "does not include paragraphs in the code blocks" do
    assert_equal "Paragraph.\n\n```\nfoo\n```",
      Guidedown.new("Paragraph.\n\n    foo\n").to_s
  end

  it "does not remove more than four spaces from code blocks" do
    assert_equal "```\n    foo\n```",
      Guidedown.new("        foo\n").to_s
  end

  it "sets the language identifier for a code block" do
    assert_equal "``` ruby\n# example.rb\ndef foo\n  puts 'bar'\nend\n```",
      Guidedown.new("    # example.rb\n    def foo\n      puts 'bar'\n    end\n").to_s
  end
end
