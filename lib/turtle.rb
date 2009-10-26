$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'turtle/builder'

module Turtle

  def self.build(out=STDOUT, extension=nil, &block)
    Builder.build out, extension, &block
  end

end
