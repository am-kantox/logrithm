module Logrithm
  module Formatters
    module Pretty
      def formatter
        proc do |severity, datetime, progname, message|
          Log::INSTANCE.send(:lead, severity, datetime) <<
            Log::INSTANCE.send(:color, severity).last.colorize(message.inspect) << $/
        end
      end
      module_function :formatter
    end
  end
end
