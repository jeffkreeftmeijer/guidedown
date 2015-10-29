require_relative 'test_helper'

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

  it "sets the language identifier from the code block comment line" do
    assert_equal "``` ruby\ndef foo\n  puts 'bar'\nend\n```",
      Guidedown.new("    # ruby\n    def foo\n      puts 'bar'\n    end\n").to_s
  end

  it "replaces code blocks with actual file contents" do
    assert_equal "``` ruby\n# examples/example.rb\ndef foo\n  puts 'bar'\nend\n```",
      Guidedown.new("    # examples/example.rb\n    def foo\n      # TODO: replace this...\n    end\n").to_s
  end

  it "takes a single line from the file" do
    assert_equal "``` ruby\n# examples/example.rb:2\n  puts 'bar'\n```",
      Guidedown.new("    # examples/example.rb:2\n      # TODO: replace this...\n").to_s
  end

  it "takes a line range from the file" do
    assert_equal "``` ruby\n# examples/example.rb:1-2\ndef foo\n  puts 'bar'\n```",
      Guidedown.new("    # examples/example.rb:1-2\n    def foo\n      # TODO: replace this...\n").to_s
  end

  it "replaces code blocks with file contents with ommitted parts" do
    assert_equal "``` ruby\n# examples/example.rb\ndef foo\n  ...\nend\n```",
      Guidedown.new("    # examples/example.rb\n    def foo\n      ...\n    end\n").to_s
  end

  it "replaces code blocks with command line output" do
    assert_equal "``` console\n$ echo foo\nfoo\n```",
      Guidedown.new("    $ echo foo\n    bar?\n").to_s
  end
end
