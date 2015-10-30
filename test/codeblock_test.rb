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

    it "uses 'console' as the info string for console code blocks" do
      assert_equal 'console',
        Guidedown::Codeblock.new('    $ echo foo').info_string
    end

    it "uses 'console' as the info string fo console code blocks with hidden commands" do
      assert_equal 'console',
        Guidedown::Codeblock.new('    # $ echo foo').info_string
    end
  end

  describe "comments" do
    it "does not have a comment" do
      assert_nil Guidedown::Codeblock.new("    ").comment
    end

    it "has a comment line for a filename" do
      assert_equal "# examples/example.rb",
        Guidedown::Codeblock.new('    # examples/example.rb').comment
    end

    it "does not have a comment line for an info string" do
      assert_nil Guidedown::Codeblock.new('    # elixir').comment
    end
  end

  describe "commands" do
    it "does not have a command" do
      assert_nil Guidedown::Codeblock.new('    ').command
    end

    it "has a command" do
      assert_equal '$ echo foo', Guidedown::Codeblock.new('    $ echo foo').command
    end

    it "does not include a hidden command" do
      assert_nil Guidedown::Codeblock.new('    # $ echo foo').command
    end
  end

  describe "code block contents" do
    it "unintents" do
      assert_equal 'foo',
        Guidedown::Codeblock.new('    foo').contents
    end

    it "does not include comment lines" do
      assert_equal '',
        Guidedown::Codeblock.new('    # elixir').contents
    end

    describe "concerning file contents" do
      it "uses file contents" do
        assert_equal "class Foo\n  def foo\n    puts 'bar'\n  end\nend\n",
          Guidedown::Codeblock.new('    # examples/example.rb').contents
      end

      it "uses a single line from a file" do
        assert_equal "    puts 'bar'\n",
          Guidedown::Codeblock.new('    # examples/example.rb:3').contents
      end

      it "uses a line range from a file as data" do
        assert_equal "class Foo\n  def foo\n",
          Guidedown::Codeblock.new('    # examples/example.rb:1-2').contents
      end
    end

    describe "concerning console output" do
      it "runs console commands" do
        assert_equal "foo\n",
          Guidedown::Codeblock.new("    $ echo foo\n    bar?").contents
      end

      it "does not run console commands for command-only code blocks" do
        codeblock = Guidedown::Codeblock.new("    $ echo foo")
        assert_equal '', codeblock.contents
      end
    end
  end

  it "has an info string" do
    codeblock = Guidedown::Codeblock.new("    # examples/example.rb")
    assert_includes "``` ruby\n", codeblock.to_s.lines[0]
  end

  it "has a comment" do
    codeblock = Guidedown::Codeblock.new("    # examples/example.rb")
    assert_equal "# examples/example.rb\n", codeblock.to_s.lines[1]
  end

  it "has a command" do
    codeblock = Guidedown::Codeblock.new("    $ echo foo")
    assert_equal "$ echo foo\n", codeblock.to_s.lines[1]
  end

  it "has contents" do
    codeblock = Guidedown::Codeblock.new("    contents\n")
    assert_equal "contents\n", codeblock.to_s.lines[1]
  end

  describe "with HTML code blocks" do
    it "uses <pre> and <code> tags instead of backticks" do
      codeblock = Guidedown::Codeblock.new("    contents\n", html_code_blocks: true)
      assert_equal "<pre><code>contents\n</code></pre>\n", codeblock.to_s
    end

    it "omits the info string" do
      codeblock = Guidedown::Codeblock.new("    # ruby", html_code_blocks: true)
      assert_equal "<pre><code></code></pre>\n", codeblock.to_s
    end
  end

  describe "without filenames" do
    it "omits filenames" do
      codeblock = Guidedown::Codeblock.new("    # examples/example.rb", no_filenames: true)
      assert_equal "``` ruby\nclass Foo\n  def foo\n    puts 'bar'\n  end\nend\n```\n", codeblock.to_s
    end
  end
end
