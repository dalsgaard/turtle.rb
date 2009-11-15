$:.unshift('lib')
require 'lib/turtle'
require 'lib/turtle/trig'

Turtle.build do

  prefix :foaf, "http://xmlns.com/foaf/0.1/"

  graph do

    subject ["http://kimdalsgaard.com#me"] do
      predicate a, [:foaf, "Person"]       
      predicate [:foaf, "name"], "Kim Dalsgaard"
      predicate [:foaf, "homepage"], ["http://kimdalsgaard.com"]
    end

  end

  graph ["http://kimdalsgaard.com/friends"] do

    subject ["http://kimdalsgaard.com#me"] do
      predicate [:foaf, "knows"] do
        object ["http://sophus.dalsgaardkirk.com#me"]
        object ["http://pernille.dalsgaardkirk.com#me"]
      end
    end

  end

end
