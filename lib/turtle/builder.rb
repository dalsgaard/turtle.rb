require 'Set'

module Turtle

  class Builder
    
    def initialize(out)
      @out = out
      @state = :object
    end

    def base(uri)
      @out.puts "@base <#{uri}> ."
    end

    def prefix(prefix, namespace)
      @out.puts "@prefix #{prefix}: <#{namespace}> ."
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

    def resolve(e)
      case e
      when Array
        ns, n = e
        "#{ns}:#{n}"
      when :a
        "a"
      when String
        "\"#{encode(e)}\""
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
