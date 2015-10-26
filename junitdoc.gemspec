Gem::Specification.new do |s|

  s.name        = 'junitdoc'
  s.version     = '0.1.0'
  s.summary     = "JUnit Doc"
  s.description = "Converts a pile of JUnit XML reports into readable documentation for your favorite product owner"
  s.license     = "MIT"
  s.authors     = ["Guy Royse"]
  s.email       = 'guy@guyroyse.com'
  s.homepage    = 'http://rubygems.org/gems/junitdoc'

  s.files       = ["lib/junitdoc.rb", "README.md", "LICENSE"]
  s.executables = ["junitdoc"]

  s.add_runtime_dependency "nokogiri", "1.6.3.1"
  s.add_runtime_dependency "haml", "4.0.7"

end
