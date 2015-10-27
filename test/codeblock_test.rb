require_relative 'test_helper'

describe Guidedown::Codeblock do
  it "converts indented codeblocks to fenced ones" do
    codeblock = Guidedown::Codeblock.new("    def foo\n      puts 'bar'\n    end\n")
    assert_equal "```\ndef foo\n  puts 'bar'\nend\n```", codeblock.to_s
  end

  it "has a language name" do
    codeblock = Guidedown::Codeblock.new("    # examples/does_not_exist.rb")
    assert_equal "ruby", codeblock.language_name
  end

  it "uses the language name as the info string" do
    codeblock = Guidedown::Codeblock.new("    # examples/does_not_exist.js")
    assert_equal "javascript", codeblock.info_string
  end

  it "takes its info string from the code block's comment" do
    codeblock = Guidedown::Codeblock.new("    # ruby")
    assert_equal "ruby", codeblock.info_string
  end

  it "uses file contents as data" do
    codeblock = Guidedown::Codeblock.new("    # examples/example.rb")
    assert_equal "def foo\n  puts 'bar'\nend\n", codeblock.unindented_data
  end

  it "uses a single line from a file as data" do
    codeblock = Guidedown::Codeblock.new("    # examples/example.rb:2")
    assert_equal "  puts 'bar'\n", codeblock.unindented_data
  end
end
