module Logrithm
  module Spitters
    class Wrapper < StandardError
    end

    class Exception
      BACKTRACE_LENGTH = Logrithm::Log.option(:log, :backtrace, :len) || 8

      def initialize(e)
        @e = e.is_a?(::Exception) ? e : Wrapper.new(e.inspect)
      end

      def formatted
        formatted = format(@e)

        msg = [
          "Error: #{formatted[:causes].map { |c| "⟨#{c.class}⟩ (“#{c.message}”)" }.join(' ⇐ ')}",
          formatted[:backtrace],
          "[#{formatted[:omitted]} more]".rjust(20, '.')
        ].join(joiner)
        '' << Logrithm::Log::INSTANCE.send(:lead, :error) << Logrithm::Utils::Output.clrz(msg, Logrithm.color(:error).last)
      end

      private

      def joiner
        "#{$/} #{Logrithm::Log.option(:log, :joiners, :exception) || '⮩ '}"
      end

      def format(e)
        bt = e.backtrace.is_a?(Array) ? e.backtrace : caller
        fbt = format_backtrace(bt)
        {
          causes: loop.each_with_object(causes: [], current: e) do |_, memo|
                    memo[:causes] << memo[:current]
                    memo[:current] = memo[:current].cause
                    break memo unless memo[:current]
                  end[:causes],
          backtrace: fbt,
          omitted: bt.size - fbt.size
        }
      end

      def format_backtrace(backtrace)
        backtrace.map.with_index do |bt, idx|
          if idx < BACKTRACE_LENGTH || bt =~ /^#{Logrithm::Log.app_root}/
            "[#{idx.to_s.rjust(3, ' ')}] " << \
              bt.gsub(/^(#{Logrithm::Log.app_root}[^:]*):(\d+):/, "⟦\\1⟧:⟦\\2⟧: ").gsub(/`(.*?)'/, "⟬\\1⟭")
          end
        end.compact
      end
    end
  end
end
