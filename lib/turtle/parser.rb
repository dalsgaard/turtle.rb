module Turtle

  class Parser

    class Uri
      attr_reader :uri
      
      def initialize(uri)
        @uri = uri
      end

      def +(rhs)
        Uri.new @uri + rhs
      end

      def to_s
        "<#{@uri}>"
      end

    end

    class Literal

      def initialize(literal, type=nil)
        @literal = literal
        @type = type
      end

      def to_s()
        type = @type ? "^^#{@type}" : ""
        "\"#{@literal}\"#{type}"
      end

    end

    attr_reader :triples

    UriExp = "<[^>]*>|[\\w-]*:[\\w-]*"
    ElemExp = "<[^>]*>|[\\w-]*:[\\w-]*|\"[^\"]*\"|\"[^\"]*\"\\^\\^[\\w-]*:[\\w-]*|\"[^\"]*\"\\^\\^<[^>]*>"

    SubjectExp = /^(@base\s+(#{UriExp}))|(@prefix\s+([\w-]*):\s+(#{UriExp}))|((#{UriExp})\s+(#{UriExp})\s+(#{ElemExp}))\s*(\.|;|,)/ 
    PredicateExp = /^(#{UriExp})\s+(#{ElemExp})\s*(\.|;|,)/
    ObjectExp = /^(#{ElemExp})\s*(\.|;|,)/

    def initialize(base="")
      @base = Uri.new(base)
      @prefixes = {}
      @triples = []
    end

    def add_triple()
      triple = [@subject, @predicate, @object]
      @triples << triple
    end

    def match_statement()
      @turtle =~ SubjectExp
      if $~
        @turtle = $~.post_match.strip
        if $2
          @base = resolve($2)
          "."
        elsif $4
          @prefixes[$4] = resolve($5)
          "."
        else
          @subject = resolve($7)
          @predicate = resolve($8)
          @object = resolve($9)
          add_triple
          $10
        end
      else
        false
      end
    end

    def match_predicate()
      if @turtle =~ PredicateExp
        @predicate = resolve($1)
        @object = resolve($2)
        add_triple
        @turtle = $~.post_match.strip
        $3
      else
        false
      end
    end

    def match_object()
      if @turtle =~ ObjectExp
        @object = resolve($1)
        add_triple
        @turtle = $~.post_match.strip
        $2
      else
        false
      end
    end

    def resolve(s)
      
      case s
      when /^<(http:.*)>$/
        Uri.new $1
      when /^<(.*)>$/
        @base + $1
      when /^([\w-]*):([\w-]*)$/
        @prefixes[$1] + $2
      when /^\"([^\"]*)\"\^\^([\w-]*:[\w-]*)$/
        Literal.new $1, resolve($2)
      when /^\"([^\"]*)\"$/
        Literal.new $1
      else
        s
      end
    end

    def parse(turtle, base=nil)
      @base = base if base
      @turtle = turtle.strip
      sep = "."
      while sep
        case sep
        when "."
          sep = match_statement
        when ";"
          sep = match_predicate
        when ","
          sep = match_object
        else
          sep = false
        end
      end
    end

  end

end
