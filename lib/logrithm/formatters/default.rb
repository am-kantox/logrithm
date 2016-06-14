module Logrithm
  module Formatters
    module Default
      def formatter
        Logrithm.rails? ? Kernel.const_get('::Rails').logger.formatter : Logger::Formatter.new
      end
      module_function :formatter
    end
  end
end
