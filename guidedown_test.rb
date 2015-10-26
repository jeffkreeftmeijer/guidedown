require 'minitest/autorun'
require_relative 'guidedown'

describe Guidedown do
  it "converts indented code blocks to fenced code blocks" do
    assert_equal "```\nfoo\n```", Guidedown.new('    foo').to_s
  end

  it "converts indented multiline code blocks to fenced code blocks" do
    assert_equal "```\nfoo\nbar\n```", Guidedown.new("    foo\n    bar").to_s
  end
end
