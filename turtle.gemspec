require 'rubygems'
require 'rake'

Gem::Specification.new do |spec|
  spec.name = 'turtle'
  spec.version = "0.0.1"
  spec.summary = "A Ruby DSL for generating RDF in the Turtle format"
  spec.description = ""
  spec.author = "Kim Dalsgaard"
  spec.email = "kim@kimdalsgaard.com"
  spec.homepage = "http://github.com/dalsgaard/turtle.rb"
  
  spec.files = FileList['lib/**/*.rb']
  spec.require_paths = ['lib']
end
