module Turtle

  class Builder
    
    def initialize(out)
      @out = out
      @state = :object
      @xsd = nil
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
        end
      end
    end

    def subject(s, p=nil, o=nil)
      @out.print "#{resolve s}"
      if p
        @out.print " #{resolve p}"
        if o
          @out.print " #{resolve o}"
          @state = :object
        else
          @state = :predicate
        end
      else
        @state = :subject
      end
      yield if block_given?
      @out.puts " ."
    end

    def predicate(p, o=nil)
      if @state == :object 
        @out.print " ;"
      end
      @out.print "\n  #{resolve p}"
      if o
        @out.print " #{resolve o}"
        @state = :object
      else
        @state = :predicate
      end
      yield if block_given?
    end

    def object(o)
      if @state == :object
        @out.print " ,"
      end
      @out.print "\n    #{resolve o}"
      @state = :object
    end

    alias s subject
    alias p predicate
    alias o object
    alias triple subject
    alias t subject

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
          ":"
        when 1
          ":#{e.first}"
        else
          first, last = e
          case first
          when Symbol
            "#{first}:#{last}"
          when String
            "\"#{first}\"^^#{xsd_datatype last}"
          end
        end
      when :a
        "a"
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

    def self.build(out=STDOUT, extension=nil, &block)
      builder = new out
      builder.extend ext if extension
      builder.instance_eval &block
    end

  end

end
