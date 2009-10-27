require 'turtle/builder'

module Turtle

  def self.build(out=STDOUT, extension=nil, &block)
    Builder.build out, extension, &block
  end

end
