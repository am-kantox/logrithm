module Logrithm
  module Spitters
    class String
      def initialize(obj)
        @obj = obj
      end

      def formatted
        case @obj
        when ::String then @obj
        when ::Symbol, ::Regexp then @obj.to_s
        else @obj.inspect
        end
      end
    end
  end
end
