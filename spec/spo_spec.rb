require 'lib/turtle/builder'

include Turtle

describe Builder do

  before :each do
    @out = StringIO.new
    @builder = Builder.new @out
    base = "http://st.arfi.sh#"
    @a = base + "a"
    @b = base + "b"
    @c = base + "c"
    @d = base + "d"
    @e = base + "e"
    @abc = /^<#{@a}>\s+<#{@b}>\s+<#{@c}>\s*\.\s*$/
    @abcd = /^<#{@a}>\s+<#{@b}>\s+<#{@c}>\s*\,\s*<#{@d}>\s*\.\s*$/
    @abcde = /^<#{@a}>\s+<#{@b}>\s+<#{@c}>\s*\;\s*<#{@d}>\s+<#{@e}>\s*\.\s*$/
  end

  it "should support simple triples" do
    _a, _b, _c = [@a], [@b], [@c]
    Builder.build @out do
      subject _a, _b, _c
    end
    @out.string.should =~ @abc
  end

  it "should support a nested predicate" do
    _a, _b, _c = [@a], [@b], [@c]
    Builder.build @out do
      subject _a do
        predicate _b, _c
      end
    end
    @out.string.should =~ @abc
  end

  it "should support nested predicates" do
    _a, _b, _c, _d, _e = [@a], [@b], [@c], [@d], [@e]
    Builder.build @out do
      subject _a do
        predicate _b, _c
        predicate _d, _e
      end
    end
    @out.string.should =~ @abcde
  end

  it "should support a nested object" do
    _a, _b, _c, _d = [@a], [@b], [@c], [@d]
    Builder.build @out do
      subject _a, _b do
        object _c
      end
    end
    @out.string.should =~ @abc
  end

  it "should support nested objects" do
    _a, _b, _c, _d = [@a], [@b], [@c], [@d]
    Builder.build @out do
      subject _a, _b do
        object _c
        object _d
      end
    end
    @out.string.should =~ @abcd
  end

  it "should support a nested object in a nested predicate" do
    _a, _b, _c, _d = [@a], [@b], [@c], [@d]
    Builder.build @out do
      subject _a do
        predicate _b do
          object _c
        end
      end
    end
    @out.string.should =~ @abc    
  end

  it "should support nested objects in a nested predicate" do
    _a, _b, _c, _d = [@a], [@b], [@c], [@d]
    Builder.build @out do
      subject _a do
        predicate _b do
          object _c
          object _d
        end
      end
    end
    @out.string.should =~ @abcd    
  end

  it "should support multiple objects in one call" do
    _a, _b, _c, _d = [@a], [@b], [@c], [@d]
    Builder.build @out do
      subject _a, _b do
        object _c, _d
      end
    end
    @out.string.should =~ @abcd
  end

  it "should support multiple objects in a call to subject" do
    _a, _b, _c, _d = [@a], [@b], [@c], [@d]
    Builder.build @out do
      subject _a, _b, _c, _d
    end
    @out.string.should =~ @abcd
  end

  it "should support multiple objects in a call to predicate" do
    _a, _b, _c, _d = [@a], [@b], [@c], [@d]
    Builder.build @out do
      subject _a do
        predicate _b, _c, _d
      end
    end
    @out.string.should =~ @abcd
  end

end
