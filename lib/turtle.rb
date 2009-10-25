require 'turtle/builder'

module Turtle

  def self.build(out=STDOUT, ext=nil, &block)
    Builder.build out, ext, &block
  end

end
