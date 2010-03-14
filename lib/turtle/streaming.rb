require 'turtle/base'

module Turtle

  class Streaming < Base
    
    def initialize(out=STDOUT)
      super out
      @expects = [:s]
      @first_child = true
    end

    def subject(s, p=nil, o=nil)
      if @first_child
        @first_child = false
      else
        @out.puts " ."
      end
      @out.print "#{resolve s}"
      if p
        @out.print " #{resolve p}"
        if o
          @out.print " #{resolve o}"
          @expects = [:s]
          indent 0
        else
          @expects = [:s, :o]
          @first_child = true
          indent 1
        end
      else
        @expects = [:s, :p]
        @first_child = true
        indent 1
      end
    end

    def predicate(p, o=nil)
      if @first_child
        @first_child = false
      else
        @out.print " ;"
      end
      indent 1
      @out.print "\n#{indent}#{resolve p}"
      if o
        @out.print " #{resolve o}"
      else
        @expects << :o
        @first_child = true
        indent 2        
      end
    end

    def object(o)
      if @first_child
        @first_child = false
      else
        @out.print " ,"
      end
      @out.print "\n#{indent}#{resolve o}"
    end

    def done()
      @out.puts " ."
    end

    alias s subject
    alias p predicate
    alias o object
    alias triple subject
    alias t subject

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
