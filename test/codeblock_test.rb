require_relative 'test_helper'

describe Guidedown::Codeblock do
  it "converts indented codeblocks to fenced ones" do
    codeblock = Guidedown::Codeblock.new("    def foo\n      puts 'bar'\n    end\n")
    assert_equal "```\ndef foo\n  puts 'bar'\nend\n```", codeblock.to_s
  end

  it "has a language name" do
    codeblock = Guidedown::Codeblock.new("    # example.rb\n    def foo\n      puts 'bar'\n    end\n")
    assert_equal "ruby", codeblock.language_name
  end

  it "takes its info string from the language name" do
    codeblock = Guidedown::Codeblock.new("    # example.rb")
    assert_equal "ruby", codeblock.info_string
  end

  it "takes its info string from the code block's comment" do
    codeblock = Guidedown::Codeblock.new("    # ruby")
    assert_equal "ruby", codeblock.info_string
  end

  it "uses file contents as data" do
    codeblock = Guidedown::Codeblock.new("    # examples/example.rb")
    assert_equal "def foo\n  puts 'bar'\nend\n", codeblock.unindented_data
  end
end
