$:.unshift('lib')
require 'lib/turtle'

Turtle.build do

  prefix :foaf, "http://xmlns.com/foaf/0.1/"

  File.open("examples/people.csv").each do |ln|
    arr = ln.split(';')
    if arr.size == 3
      subject _ do
        predicate a, [:foaf, "Person"]
        predicate [:foaf, "name"], arr[0].strip
        predicate [:foaf, "homepage"], [arr[1].strip]
        predicate [:foaf, "nick"], arr[0].strip
      end
    end
  end

end

