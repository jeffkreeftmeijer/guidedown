# Guidedown

Guidedown is a Markdown preprocessor that helps you write and maintain software guides. It uses simple and readable indented code blocks and transforms them to [fenced](https://help.github.com/articles/github-flavored-markdown/#fenced-code-blocks), syntax highlighted ones. Also, it'll make sure your code samples are always up to date by copying actual file contents and running console commands.

## Getting started

First, install Guidedown from Rubygems:

    $ gem install guidedown
    
After installing you'll have a `guidedown` executable you can pass Markdown files to:

    $ bin/guidedown examples/code_block.md
    This is a paragraph.

    ```
    def foo
      puts 'bar'
    end
    ```

## Code blocks

Indented code blocks are converted to fenced code blocks. Given a file named `examples/code_block.md`, with these contents:


    # examples/code_block.md
    This is a paragraph.

        def foo
          puts 'bar'
        end

The four spaces indenting the block will be removed, and the code will be wrapped in backticks:

    $ bin/guidedown examples/code_block.md
    ``` markdown
    # examples/code_block.md
    This is a paragraph.

    def foo
      puts 'bar'
    end
    ```

### Syntax highlighting

When passing a filename as a comment in the first line of a code block, Guidedown will try to determine the file's language. Given a file named `examples/syntax_highlighting.md`, with these contents:

    # examples/syntax_highlighting.md
        # example.rb
        def foo
          puts 'bar'
        end

Guidedown will use the filename and the file's contents to find out that this is an Ruby file and set the language identifier accordingly:

    $ bin/guidedown examples/syntax_highlighting.md
    ``` ruby
    # example.rb
    def foo
      puts 'bar'
    end
    ```

If your code block doesn't have a file, you can use the comment line to set the language identifier directly. Given a file named `examples/syntax_highlighting_comment.md`, with these contents:

    # examples/syntax_highlighting_comment.md
        # ruby
        def foo
          puts 'bar'
        end

Guidedown will use the comment line as the language identifier in the resulting code block:

    $ bin/guidedown examples/syntax_highlighting_comment.md
    ``` ruby
    # example.rb
    def foo
      puts 'bar'
    end
    ```

### Code block replacement

When specitying a filename for a code block, Guidedown will try to find the file and replace the block's contents with the actual contents from the file. Given a file named `examples/code_block_replacement.md`, with these contents:

    # examples/code_block_replacement.md
        # examples/example.rb
        def foo
          # TODO: replace this with the actual contents from `examples/example.rb`.
        end

Guidedown will replace everything in the code block with the actual contents from the file:

    $ bin/guidedown examples/code_block_replacement.md
    ``` ruby
    # example.rb
    def foo
      puts 'bar'
    end
    ```
    
#### Truncating file contents

If you only want to show part of a file, you can truncate the code block by passing the range of lines you want to include. Given a file named `example-line-range.md` with the following contents:

    $ bin/guidedown examples/code_block_replacement_line_range.md
        # examples/example.rb:1-2
        def foo
          # TODO: replace this with the actual line from `examples/example.rb:1-2`.
    .md
    
Guidedown will replace the code block with the range of lines specified:
    
    $ bin/guidedown examples/code_block_replacement_line_range.md
    ``` ruby
    # examples/example.rb:1-2
    def foo
      puts 'bar'
    ```
    
Single lines work too. Given a file named `example-single-line.md` with the following contents:

    # examples/code_block_replacement_single_line.md
        # examples/example.rb:2
        # TODO: replace this with the actual line from `examples/example.rb:2`.
        
Guidedown will replace the code block with the line specified:

    $ bin/guidedown examples/code_block_replacement_single_line.md
    ``` ruby
    # examples/example.rb:2
      puts 'bar'
    ```
    
#### Omitting parts of files

Alternatively, you can use ellipses to omit parts of an included file. Given a file named `example-ellipsis.md` with the following contents:

    # examples/code_block_replacement_ellipsis.md
        # examples/example.rb
        def foo
          ...
        end
        
Guidedown will use the pattern from the code block to find out which lines to include and which to omit:

    $ bin/guidedown examples/code_block_replacement_ellipsis.md
    ``` ruby
    # examples/example.rb
    def foo
      ...
    end
    ```

### Console output

Guidedown can run console commands and put the output in the guide. Given a file named `examples/code_block_replacement_console_output.md` with the following contents:

    # examples/code_block_replacement_console_output.md
        $ echo "foo"
        bar?

Guidedown will run the command (`$echo "foo"`), and replace the rest of the code block with its output:

    $ bin/guidedown examples/code_block_replacement_console_output.md
    ``` console
    $ echo 'foo'
    foo
    ```

If you want to include the command's results in your code block, but not the command, you can use `# $`. Given a file named `examples/code_block_replacement_console_output_hidden_command.md` with the following contents:

    # examples/code_block_replacement_console_output_hidden_command.md
        # $ echo "foo"
        bar?

Guidedown will run the command like before, but won't put the command line in the resulting output:

    $ bin/guidedown examples/code_block_replacement_console_output_hidden_command.md
    ``` console
    foo
    ```

Of course, it's also possible to just show the command, without running it. Given a file named `examples/code_block_replacement_command_without_output.md` with the following contents:

    # examples/code_block_replacement_command_without_output.md
        $ gem install guidedown

Guidedown will just give you the command in a code block:

    $ bin/guidedown examples/code_block_replacement_command_without_output.md
    ``` console
    $ gem install guidedown
    ```
