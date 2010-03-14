require 'lib/turtle/builder'

include Turtle

describe Builder do

  before :each do
    @out = StringIO.new
  end

  it 'should resolve [] as "<>"' do
    Builder.build do
      resolve([]).should == "<>"
    end
  end

  it 'should resolve [_] as ":"' do
    Builder.build do
      resolve([_]).should == ":"
    end
  end

  it 'should resolve [:symbol] as symbol:' do
    Builder.build do
      resolve([:foo]).should == "foo:"
    end
  end

  it 'should resolve ["string"] as <string>' do
    uri = "http://st.arfi.sh/foo#"
    Builder.build do
      resolve([uri]).should == "<#{uri}>"
    end
  end

  it 'should resolve [:_, :_] as :' do
    Builder.build do
      resolve([_, _]).should == ":"
    end
  end

  it 'should resolve [:_, "string"] as :string' do
    Builder.build do
      resolve([_, "foo"]).should == ":foo"
    end
  end

  it 'should resolve [:symbol, :_] as symbol:' do
    Builder.build do
      resolve([:foo, _]).should == "foo:"
    end
  end

  it 'should resolve [:symbol, "string"] as symbol:string' do
    Builder.build do
      resolve([:foo, 'bar']).should == "foo:bar"
    end
  end

  it 'should resolve ["string1", "string2"] as "string1"^^xsd:string2' do
    Builder.build @out do
      prefix :xsd
      resolve(["Foo", "string"]).should == "\"Foo\"^^xsd:string"
    end
  end

  it 'should resolve :_ as a blank node' do
    Builder.build do
      resolve(_).should =~ /_:\w+/
    end
  end

  it 'should resolve a as a' do
    Builder.build do
      resolve(a).should == "a"                        
    end
  end

end
