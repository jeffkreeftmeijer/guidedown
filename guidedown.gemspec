require 'date'

Gem::Specification.new do |s|
  s.name        = 'guidedown'
  s.version     = '0.1.0'
  s.date        = Date.today.to_s
  s.summary     = "Guidedown"
  s.description = "Guidedown is a Markdown preprocessor that helps you write and maintain software guides."
  s.authors     = ["Jeff Kreeftmeijer"]
  s.email       = 'jeff@kreeftmeijer.nl'
  s.files       = ["lib/guidedown.rb"]
  s.executables = ["guidedown"]
  s.homepage    = 'https://github.com/jeffkreeftmeijer/guidedown'
  s.license     = 'MIT'
end
