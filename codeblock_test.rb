require 'minitest/autorun'
require_relative 'guidedown'

describe Guidedown::Codeblock do
  it "converts indented codeblocks to fenced ones" do
    codeblock = Guidedown::Codeblock.new("    def foo\n      puts 'bar'\n    end\n")
    assert_equal "```\ndef foo\n  puts 'bar'\nend\n```", codeblock.to_s
  end

  it "has a language name" do
    codeblock = Guidedown::Codeblock.new("    # example.rb\n    def foo\n      puts 'bar'\n    end\n")
    assert_equal "ruby", codeblock.language_name
  end
end
