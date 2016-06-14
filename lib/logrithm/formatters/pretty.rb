module Logrithm
  module Formatters
    module Pretty
      def formatter
        proc do |severity, datetime, _, message|
          '' <<
            Log::INSTANCE.send(:lead, severity, datetime) <<
            parse(message).map do |formatted|
              Log::INSTANCE.send(:color, severity).last.colorize(formatted)
            end.join(Logrithm::Log::JOINER) << $/
        end
      end
      module_function :formatter

      def parse(message)
        return enum_for(:parse, message) unless block_given?
        [*message].each do |obj|
          klazz = obj.class.ancestors.inject(nil) do |memo, k|
            memo || Utils::Helpers.constantize(k, Logrithm::Spitters)
          end || Utils::Helpers.constantize(:string, Logrithm::Spitters)
          yield klazz.new(obj).formatted
        end
      end
      module_function :parse
    end
  end
end
