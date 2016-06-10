module Logrithm
  module Formatters
    module Default
      def formatter
        rails? ? Kernel.const_get('::Rails').logger.formatter : Logger::Formatter.new
      end
      module_function :formatter
    end
  end
end
