require 'guidedown'

puts Guidedown.new(
  File.read('examples/code_block_replacement.md'),
  no_filenames: true
).to_s
