require 'minitest/autorun'
require_relative 'guidedown'

describe Guidedown do
  it "converts indented code blocks to fenced code blocks" do
    assert_equal "```\nfoo\n```", Guidedown.new('    foo').to_s
  end
end
