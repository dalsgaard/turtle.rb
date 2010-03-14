# To be run from the project folder - 'ruby examples/streaming.rb' 

$:.unshift('lib')
require 'lib/turtle'
require 'lib/turtle/streaming'

s = Turtle::Streaming.new

s.subject [:foo, "foo"], [:foo, "bar"], "Baz"

s.subject [:foo, "foo"]
s.predicate [:foo, "bar"], "Foo"
s.predicate [:foo, "bar"], "Bar"
s.predicate [:foo, "bar"], "Baz"

s.subject [:foo, "foo"]
s.predicate [:foo, "bar"]
s.object "Foo"
s.object "Bar"
s.predicate [:foo, "bar"], "Baz"

s.subject [:foo, "foo"], [:foo, "bar"]
s.object "Foo"
s.object "Bar"

s.done
