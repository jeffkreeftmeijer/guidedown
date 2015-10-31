# Guidedown

Guidedown is a Markdown preprocessor that helps you write and maintain software guides. It uses simple and readable indented code blocks and transforms them to [fenced](https://help.github.com/articles/github-flavored-markdown/#fenced-code-blocks), syntax highlighted ones. Also, it'll make sure your code samples are always up to date by copying actual file contents and running console commands.

## Getting started

First, install Guidedown from Rubygems:

<pre><code>$ gem install guidedown
</code></pre>
    
After installing you'll have a `guidedown` executable you can pass Markdown files to:

<pre><code>$ bin/guidedown examples/code_block.md
This is a paragraph.

```
def foo
  puts 'bar'
end
```

This is another paragraph.
</code></pre>

You can pipe strings to it, if that's your thing:

<pre><code>$ cat examples/code_block.md | bin/guidedown
This is a paragraph.

```
def foo
  puts 'bar'
end
```

This is another paragraph.
</code></pre>

There are some command line options you can pass, like `--no-filenames`, which removes file names from code blocks:

<pre><code>$ bin/guidedown examples/code_block_replacement.md --no-filenames
``` ruby
class Foo
  def foo
    puts 'bar'
  end
end
```
</code></pre>

Lastly, you can use `Guidedown` straight from Ruby:

<pre><code>require 'guidedown'

puts Guidedown.new(
  File.read('examples/code_block_replacement.md'),
  no_filenames: true
).to_s
</code></pre>

Which would produce the same result as before:

<pre><code>$ ruby examples/guidedown_from_ruby.rb
``` ruby
class Foo
  def foo
    puts 'bar'
  end
end
```
</code></pre>

## Code blocks

Indented code blocks are converted to fenced code blocks. Given a file named `examples/code_block.md`, with these contents:


<pre><code>This is a paragraph.

    def foo
      puts 'bar'
    end

This is another paragraph.
</code></pre>

The four spaces indenting the block will be removed, and the code will be wrapped in backticks:

<pre><code>$ bin/guidedown examples/code_block.md
This is a paragraph.

```
def foo
  puts 'bar'
end
```

This is another paragraph.
</code></pre>

### Syntax highlighting

When passing a filename as a comment in the first line of a code block, Guidedown will try to determine the file's language. Given a file named `examples/syntax_highlighting.md`, with these contents:

<pre><code>    # examples/example.rb
    class Foo
      def foo
        puts 'bar'
      end
    end
</code></pre>

Guidedown will use the filename and the file's contents to find out that this is an Ruby file and set the language identifier accordingly:

<pre><code>$ bin/guidedown examples/syntax_highlighting.md
``` ruby
# examples/example.rb
class Foo
  def foo
    puts 'bar'
  end
end
```
</code></pre>

If your code block doesn't have a file, you can use the comment line to set the language identifier directly. Given a file named `examples/syntax_highlighting_comment.md`, with these contents:

<pre><code>    # ruby
    class Foo
      def foo
        puts 'bar'
      end
    end
</code></pre>

Guidedown will use the comment line as the language identifier in the resulting code block:

<pre><code>$ bin/guidedown examples/syntax_highlighting_comment.md
``` ruby
class Foo
  def foo
    puts 'bar'
  end
end
```
</code></pre>

### Code block replacement

When specifying a filename for a code block, Guidedown will try to find the file and replace the block's contents with the actual contents from the file. Given a file named `examples/code_block_replacement.md`, with these contents:

<pre><code>    # examples/example.rb
    class Foo
      # TODO: replace this with the actual contents from `examples/example.rb`.
    end
</code></pre>

Guidedown will replace everything in the code block with the actual contents from the file:

<pre><code>$ bin/guidedown examples/code_block_replacement.md
``` ruby
# examples/example.rb
class Foo
  def foo
    puts 'bar'
  end
end
```
</code></pre>
    
#### Truncating file contents

If you only want to show part of a file, you can truncate the code block by passing the range of lines you want to include. Given a file named `examples/code_block_replacement_line_range.md` with the following contents:

<pre><code>$ bin/guidedown examples/code_block_replacement_line_range.md
``` ruby
# examples/example.rb:2-4
  def foo
    puts 'bar'
  end
```
</code></pre>
    
Guidedown will replace the code block with the range of lines specified:
    
<pre><code>$ bin/guidedown examples/code_block_replacement_line_range.md
``` ruby
# examples/example.rb:2-4
  def foo
    puts 'bar'
  end
```
</code></pre>
    
Single lines work too. Given a file named `examples/code_block_replacement_single_line.md` with the following contents:

<pre><code>    # examples/example.rb:3
    # TODO: replace this with the actual line from `examples/example.rb:3`.
</code></pre>
Guidedown will replace the code block with the line specified:

<pre><code>$ bin/guidedown examples/code_block_replacement_single_line.md
``` ruby
# examples/example.rb:3
    puts 'bar'
```
</code></pre>
    
#### Omitting parts of files

Alternatively, you can use ellipses to omit parts of an included file. Given a file named `examples/code_block_replacement_ellipsis.md` with the following contents:

<pre><code>    # examples/example.rb
    class Foo
      ...
    end
</code></pre>

Guidedown will use the pattern from the code block to find out which lines to include and which to omit:

<pre><code>$ bin/guidedown examples/code_block_replacement_ellipsis.md
``` ruby
# examples/example.rb
class Foo
  ...
end
```
</code></pre>

### Console output

Guidedown can run console commands and put the output in the guide. Given a file named `examples/code_block_replacement_console_output.md` with the following contents:

<pre><code>    $ echo 'foo'
    bar?
</code></pre>

Guidedown will run the command (`$ echo 'foo'`), and replace the rest of the code block with its output:

<pre><code>$ bin/guidedown examples/code_block_replacement_console_output.md
``` console
$ echo 'foo'
foo
```
</code></pre>

If you want to include the command's results in your code block, but not the command, you can use `# $`. Given a file named `examples/code_block_replacement_console_output_hidden_command.md` with the following contents:

<pre><code>    # $ echo 'foo'
    bar?
</code></pre>

Guidedown will run the command like before, but won't put the command line in the resulting output:

<pre><code>$ bin/guidedown examples/code_block_replacement_console_output_hidden_command.md
``` console
foo
```
</code></pre>

Of course, it's also possible to just show the command, without running it. Given a file named `examples/code_block_replacement_command_without_output.md` with the following contents:

<pre><code>    $ gem install guidedown
</code></pre>

Guidedown will just give you the command in a code block:

<pre><code>$ bin/guidedown examples/code_block_replacement_command_without_output.md
``` console
$ gem install guidedown
```
</code></pre>
