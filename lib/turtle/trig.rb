module Turtle

  class Builder

    def graph(name=nil)
      @out.print "#{resolve name} = " if name
      @out.puts "{"
      if block_given?
        @indent += 1
        yield
        @indent -= 1
      end
      @out.puts "} ."      
    end

  end

end
