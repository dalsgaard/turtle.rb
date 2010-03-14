require 'turtle/base'

module Turtle

  class Builder < Base
    
    def initialize(out=STDOUT)
      super out
      @state = :object
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
