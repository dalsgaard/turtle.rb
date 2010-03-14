
module Turtle

  module Resolve

    def xsd_datatype(datatype)
      if @xsd
        "#{@xsd}:#{datatype}"
      else
        "<http://www.w3.org/2001/XMLSchema##{datatype}>"
      end
    end

    def resolve(e)
      case e
      when Array
        case e.size
        when 0
          "<>"
        when 1
          first = e.first
          case first
          when :blank, :_
            ":"
          when Symbol
            "#{first}:"
          when String
            "<#{e.first}>"
          end
        else
          first, last = e
          case first
          when :blank, :_
            case last
            when :blank, :_
              ":"
            else
              ":#{last}"
            end
          when Symbol
            case last
            when :blank, :_
              "#{first}:"
            else
              "#{first}:#{last}"
            end
          when String
            "\"#{first}\"^^#{xsd_datatype last}"
          end
        end
      when :blank, :_
        resolve blank
      when :a
        "a"
      when BlankNode
        e.to_s
      when Symbol
        resolve blank(e)
      when String
        "\"#{encode(e)}\""
      when Fixnum
        "\"#{e}\"^^#{xsd_datatype :integer}"
      when Float
        "\"#{e}\"^^#{xsd_datatype :double}"
      when true, false
        "\"#{e}\"^^#{xsd_datatype :boolean}"
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

  end

end
