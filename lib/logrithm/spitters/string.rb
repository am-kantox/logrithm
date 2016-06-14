module Logrithm
  module Spitters
    class String
      def initialize(obj)
        @obj = obj
      end

      def formatted
        str = case @obj
              when String then @obj
              when Symbol, Regexp then @obj.to_s
              else @obj.inspect
              end
        # Logrithm::Utils::Output.clrz(str, Logrithm.color(:error).last)
      end
    end
  end
end
