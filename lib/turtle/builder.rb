module Turtle

  class BlankNode

    def initialize(name)
      @name = name
    end

    def to_s()
      "_:#{@name}"
    end

  end

  class Builder
    
    def initialize(out=STDOUT)
      @out = out
      @state = :object
      @xsd = nil
      @blank = 0
      @indent = 0
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

    def subject(s, p=nil, *os, &block)
      @out.print "#{indent}#{resolve s}"
      if p
        @out.print " #{resolve p}"
        case os.size
        when 0
          @state = :predicate
          indent &block
        when 1
          @out.print " #{resolve os.first}"
          @state = :object
        else
          indent do
            @state = :predicate
            object *os
          end
        end
      else
        @state = :subject
        indent &block
      end
      @out.puts " ."
    end

    def predicate(p, *os, &block)
      if @state == :object 
        @out.print " ;"
      end
      @out.print "\n#{indent}#{resolve p}"
      case os.size
      when 0
        @state = :predicate
        indent &block
      when 1
        @out.print " #{resolve os.first}"
        @state = :object
      else
        @state = :predicate
        indent do
          object *os
        end        
      end
    end

    def object(*os)
      os.each do |o| 
        if @state == :object
          @out.print " ,"
        end
        @out.print "\n#{indent}#{resolve o}"
        @state = :object
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

    alias s subject
    alias p predicate
    alias o object
    alias triple subject
    alias t subject
    alias c comment
    alias nl newline

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
      
    def xsd_datatype(datatype)
      if @xsd
        "#{@xsd}:#{datatype}"
      else
        "<http://www.w3.org/2001/XMLSchema##{datatype}>"
      end
    end

    def resolve(e)
      case e
      when Array
        case e.size
        when 0
          "<>"
        when 1
          first = e.first
          case first
          when :blank, :_
            ":"
          when Symbol
            "#{first}:"
          when String
            "<#{e.first}>"
          end
        else
          first, last = e
          case first
          when :blank, :_
            case last
            when :blank, :_
              ":"
            else
              ":#{last}"
            end
          when Symbol
            case last
            when :blank, :_
              "#{first}:"
            else
              "#{first}:#{last}"
            end
          when String
            "\"#{first}\"^^#{xsd_datatype last}"
          end
        end
      when :blank, :_
        resolve blank
      when :a
        "a"
      when BlankNode
        e.to_s
      when Symbol
        resolve blank(e)
      when String
        "\"#{encode(e)}\""
      when Fixnum
        "\"#{e}\"^^#{xsd_datatype :integer}"
      when Float
        "\"#{e}\"^^#{xsd_datatype :double}"
      when true, false
        "\"#{e}\"^^#{xsd_datatype :boolean}"
      else
        e
      end
    end

    def encode(s)
      a = s.codepoints.collect do |p|
        case p
        when 34 then "\\\""
        when 92 then "\\\\"
        when 0..127 then p.chr
        else
          "\\u#{sprintf("%X", p).rjust(4, "0")}"
        end
      end
      a.join
    end

    def indent()
      if block_given?
        @indent += 1
        yield self
        @indent -= 1
      else
        "  " * @indent
      end
    end

    def self.build(out=STDOUT, *extensions, &block)
      builder = new out
      extensions.each do |extension|
        builder.extend extension
        builder.init if builder.respond_to? :init
      end
      builder.instance_eval &block
    end

  end

end
