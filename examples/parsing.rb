$:.unshift('lib')
require 'lib/turtle/parser'

turtle = %Q{
@base <http://foo.bar/> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix foo: <http://kimdalsgaard.com/foo/> .
@prefix : <http://kimdalsgaard.com#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#>

:foo-bar  dc:title
  "Foo.",
  "1234"^^xsd:integer .
foo:bar
  :foo "Bar";
  :bar <bar>.
@base <baz/> .
<foo>
  dc:knows
    <kim>  ,
    <bar> ,
    foo:.
}

parser = Turtle::Parser.new
parser.parse turtle

parser.triples.each do |triple|
  puts triple.join(" ")
end
