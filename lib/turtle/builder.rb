require 'Set'

module Turtle

  class Builder
    
    def initialize(out)
      @out = out
    end

    def base(uri)
      @out.puts "@base <#{uri}> ."
    end

    def prefix(prefix, namespace)
      @out.puts "@prefix #{prefix}: <#{namespace}> ."
    end

    def triple(s, p, o)
      @out.print "#{resolve s} #{resolve p} #{resolve o}"
      yield if block_given?
      @out.puts " ."
    end

    def predicate(p, o)
      @out.print ";\n  #{resolve p} #{resolve o}"
    end

    def object(o)
      @out.print ",\n  #{resolve o}"
    end

    def triples(s, p, os)
      @out.print "#{resolve s} #{resolve p} "
      if os.first.is_a? Symbol
        ns = os.first.to_s
        @out.print (os.last.map {|n| "#{ns}:#{n}"}).join(", ")
      else
        @out.print (os.map {|o| resolve o}).join(", ")
      end
      @out.puts " ."      
    end

    alias t triple
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

    def self.build(out=STDOUT, ext=nil, &block)
      builder = new out
      builder.extend ext if ext
      builder.instance_eval &block
    end

  end

end
