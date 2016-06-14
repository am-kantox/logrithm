module Logrithm
  module Formatters
    module Pretty
      def formatter
        proc do |severity, datetime, _, message|
          if empty?(message)
            ''
          else
            '' <<
              Log::INSTANCE.send(:lead, severity, datetime) <<
              parse(message).map do |formatted|
                Log::INSTANCE.send(:color, severity).last.colorize(formatted)
              end.join(Logrithm::Log::JOINER) << $/
          end
        end
      end
      module_function :formatter

      class << self
        def parse(message)
          return enum_for(:parse, message) unless block_given?
          [*message].each do |obj|
            klazz = obj.class.ancestors.inject(nil) do |memo, k|
              memo || Utils::Helpers.constantize(k, Logrithm::Spitters)
            end || Utils::Helpers.constantize(:string, Logrithm::Spitters)
            yield klazz.new(obj).formatted unless empty?(obj)
          end
        end

        def empty?(message)
          return true if message.nil?
          message = message.strip if message.respond_to?(:strip)
          return true if message.respond_to?(:empty?) && message.empty?
          return true if message.respond_to?(:blank?) && message.blank?
          false
        end
      end
    end
  end
end
