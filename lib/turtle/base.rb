require 'turtle/resolve'

module Turtle

  class BlankNode

    def initialize(name)
      @name = name
    end

    def to_s()
      "_:#{@name}"
    end

  end

  class Base
    include Resolve

    def initialize(out=STDOUT)
      @out = out
      @xsd = nil
      @indent = 0
      @blank = 0
    end

    def base(uri)
      @out.puts "@base <#{uri}> ."
    end

    def prefix(prefix, namespace=nil)
      if namespace
        @out.puts "@prefix #{prefix}: <#{namespace}> ."
        @xsd = prefix if namespace == "http://www.w3.org/2001/XMLSchema#"
      else
        case prefix
        when :xsd
          prefix(:xsd, "http://www.w3.org/2001/XMLSchema#")
        when :rdf
          prefix(:rdf, "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
        when :rdfs
          prefix(:rdfs, "http://www.w3.org/2000/01/rdf-schema#")
        when :owl
          prefix(:owl, "http://www.w3.org/2002/07/owl#")
        when String
          @out.puts "@prefix : <#{prefix}> ."          
        end
      end
    end

    def comment(text)
      @out.print "#{indent}# #{text}\n"
    end

    def newline
      @out.print "\n"
    end

    def blank(name=nil)
      unless name
        name = "b#{@blank}"
        @blank += 1
      end
      BlankNode.new name
    end

    def _(name=nil)
      if name
        blank name
      else
        :_
      end
    end

    def a()
      :a
    end
      
    def indent(level=nil)
      if block_given?
        @indent += 1
        yield self
        @indent -= 1
      elsif level
        @indent = level
      else
        "  " * @indent
      end
    end

    alias c comment
    alias nl newline

  end

end
