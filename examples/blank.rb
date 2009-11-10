$:.unshift('lib')
require 'lib/turtle'

Turtle.build do

  prefix :ex, "http://kimdalsgaard.com/example#"
  prefix "http://kimdalsgaard.com/example/foo#"
  nl

  s blank("foo"), [:ex, "title"], "Foo"
  s blank, [:ex, "title"], "Bar"
  nl

  s :blank, [:ex, "title"], "Foo"
  s :_, [:ex, "title"], "Bar"
  nl

  s _, [:ex, "title"], "Foo"
  s _("foo"), [:ex, "title"], "Foo"
  nl

  s :foo, [:ex, "title"], "Foo"
  nl

  a = blank
  b = blank
  s a, [:ex, :knows], b
  s b, [:ex, :knows], a
  nl

end
