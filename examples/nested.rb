$:.unshift('lib')
require 'lib/turtle'

Turtle.build do

  prefix :foaf, "http://xmlns.com/foaf/0.1/"

  subject ["http://kimdalsgaard.com#me"] do
    predicate a, [:foaf, "Person"]       
    predicate [:foaf, "knows"] do
      object ["http://sophus.dalsgaardkirk.com#me"]
      object ["http://pernille.dalsgaardkirk.com#me"]
    end
  end

end

