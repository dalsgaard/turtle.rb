require 'lib/turtle/builder'

include Turtle

describe BlankNode do

  it "should return turtle syntax when to_s is called" do
    blank = BlankNode.new "foo"
    blank.to_s.should == "_:foo"
  end

end

describe Builder do

  before :each do
    @out = StringIO.new
    @builder = Builder.new @out
  end

  it "should support @base" do
    uri = "http://st.arfi.sh/base/"
    @builder.base uri
    @out.string.should =~ /^@base\s+<#{uri}>\s*.\s*$/
  end

  # prefix

  it "should support @prefix" do
    prefix = :foo
    uri = "http://st.arfi.sh/foo#"
    @builder.prefix(prefix, uri)
    @out.string.should =~ /^@prefix\s+#{prefix}:\s+<#{uri}>\s*.\s*$/
  end

  it "should support default prefix" do
    uri = "http://st.arfi.sh/foo#"
    @builder.prefix(uri)
    @out.string.should =~ /^@prefix\s+:\s+<#{uri}>\s*.\s*$/
  end

  it "should support xsd prefix" do
    prefix = :xsd
    uri = "http://www.w3.org/2001/XMLSchema#"
    @builder.prefix(prefix)
    @out.string.should =~ /^@prefix\s+#{prefix}:\s+<#{uri}>\s*.\s*$/
  end

  it "should support rdf prefix" do
    prefix = :rdf
    uri = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    @builder.prefix(prefix)
    @out.string.should =~ /^@prefix\s+#{prefix}:\s+<#{uri}>\s*.\s*$/
  end

  it "should support rdfs prefix" do
    prefix = :rdfs
    uri = "http://www.w3.org/2000/01/rdf-schema#"
    @builder.prefix(prefix)
    @out.string.should =~ /^@prefix\s+#{prefix}:\s+<#{uri}>\s*.\s*$/
  end

  it "should support owl prefix" do
    prefix = :owl
    uri = "http://www.w3.org/2002/07/owl#"
    @builder.prefix(prefix)
    @out.string.should =~ /^@prefix\s+#{prefix}:\s+<#{uri}>\s*.\s*$/
  end

  it "should support custom XMLSchema prefix" do
    prefix = :xs
    uri = "http://www.w3.org/2001/XMLSchema#"
    @builder.prefix(prefix, uri)
    @builder.xsd_datatype("Integer").should == "xs:Integer"
  end

end
