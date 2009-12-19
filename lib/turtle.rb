require 'turtle/builder'

module Turtle

  def self.build(out=STDOUT, *extensions, &block)
    Builder.build out, *extensions, &block
  end

end
