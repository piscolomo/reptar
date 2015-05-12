require "./lib/reptar"

Gem::Specification.new do |s|
  s.name              = "reptar"
  s.version           = Reptar::VERSION
  s.summary           = "Microlibrary for write representations of objects to your JSON APIs."
  s.description       = "Microlibrary for write representations of objects to your JSON APIs."
  s.authors           = ["Julio Lopez"]
  s.email             = ["ljuliom@gmail.com"]
  s.homepage          = "http://github.com/TheBlasfem/reptar"
  s.files = Dir[
    "LICENSE",
    "README.md",
    "lib/**/*.rb",
    "*.gemspec",
    "test/**/*.rb"
  ]
  s.license           = "MIT"
  s.add_development_dependency "cutest", "1.1.3"
end