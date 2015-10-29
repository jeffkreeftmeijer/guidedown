require_relative 'test_helper'

describe Guidedown::Codeblock do
  describe "info strings" do
    it "does not have an info string" do
      assert_nil Guidedown::Codeblock.new("    ").info_string
    end

    it "uses its language name as the info string" do
      assert_equal 'ruby',
        Guidedown::Codeblock.new('    # examples/example.rb').info_string
    end

    it "does not find a language name if the file doesn't exist" do
      assert_equal 'examples/does_not_exist.rb',
        Guidedown::Codeblock.new('    # examples/does_not_exist.rb').info_string
    end

    it "uses the comment line as the info string" do
      assert_equal 'elixir',
        Guidedown::Codeblock.new('    # elixir').info_string
    end

    it "uses 'console' as the info string" do
      assert_equal 'console',
        Guidedown::Codeblock.new('    $ echo foo').info_string
    end
  end

  describe "comments" do
    it "does not have a comment" do
      assert_nil Guidedown::Codeblock.new("    ").comment
    end

    it "has a comment line for a filename" do
      assert_equal "# examples/example.rb", Guidedown::Codeblock.new("    # examples/example.rb").comment
    end

    it "does not have a comment line for an info string" do
      assert_nil Guidedown::Codeblock.new("    # elixir").comment
    end
  end

  it "converts indented codeblocks to fenced ones" do
    codeblock = Guidedown::Codeblock.new("    def foo\n      puts 'bar'\n    end\n")
    assert_equal "```\ndef foo\n  puts 'bar'\nend\n```", codeblock.to_s
  end

  it "has a language name" do
    codeblock = Guidedown::Codeblock.new("    # examples/does_not_exist.rb")
    assert_equal "ruby", codeblock.language_name
  end

  it "removes info string comments" do
    codeblock = Guidedown::Codeblock.new("    # ruby")
    assert_equal "", codeblock.unindented_data
  end

  it "removes hidden command comments from the code block's contents" do
    codeblock = Guidedown::Codeblock.new("    # $ echo")
    assert_equal "\n", codeblock.unindented_data
  end

  it "uses file contents as data" do
    codeblock = Guidedown::Codeblock.new("    # examples/example.rb")
    assert_equal "def foo\n  puts 'bar'\nend\n", codeblock.unindented_data
  end

  it "uses a single line from a file as data" do
    codeblock = Guidedown::Codeblock.new("    # examples/example.rb:2")
    assert_equal "  puts 'bar'\n", codeblock.unindented_data
  end

  it "uses a line range from a file as data" do
    codeblock = Guidedown::Codeblock.new("    # examples/example.rb:1-2")
    assert_equal "def foo\n  puts 'bar'\n", codeblock.unindented_data
  end

  it "runs console commands" do
    codeblock = Guidedown::Codeblock.new("    $ echo foo")
    assert_equal "$ echo foo\nfoo\n", codeblock.unindented_data
  end

  it "uses 'console' as the language name for console commands" do
    codeblock = Guidedown::Codeblock.new("    $ echo foo")
    assert_equal "console", codeblock.language_name
  end
end
