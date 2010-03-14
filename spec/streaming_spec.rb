require 'lib/turtle/streaming'

module Turtle

  class Streaming
    attr_reader :expects
  end

end

include Turtle

describe Streaming do

  before :each do
    @out = StringIO.new
    @streaming = Streaming.new @out
  end

  it "should initially expect [:s]" do
    @streaming.expects.should == [:s]
  end
  
  it "should expect [:s] after 'spo'" do
    @streaming.subject :foo
    @streaming.predicate [:foo, "bar"], "Baz"
    @streaming.subject :foo, [:foo, "bar"], "Baz"
    @streaming.expects.should == [:s]
  end
  
  it "should expect [:s, :p] after 's'" do
    @streaming.subject :foo
    @streaming.expects.should == [:s, :p]
  end

  it "should expect [:s, :p, :o] after 's', 'p'" do
    @streaming.subject :foo
    @streaming.predicate [:foo, "bar"]
    @streaming.expects.should == [:s, :p, :o]
  end

  it "should expect [:s, :p, :o] after 's', 'p', 'o'" do
    @streaming.subject :foo
    @streaming.predicate [:foo, "bar"]
    @streaming.object "Baz"
    @streaming.expects.should == [:s, :p, :o]
  end

  it "should expect [:s, :o] after 'sp'" do
    @streaming.subject :foo, [:foo, "bar"]
    @streaming.expects.should == [:s, :o]
  end

  it "should expect [:s, :o] after 'sp', 'o'" do
    @streaming.subject :foo, [:foo, "bar"]
    @streaming.object "Baz"
    @streaming.expects.should == [:s, :o]
  end

end
