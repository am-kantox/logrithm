require 'logger'
require 'io/console'

# rubocop:disable Style/GlobalVars
module Logrithm
  class Log
    include Kungfuig

    JOINER = "#{$/} #{option(:log, :joiners, :objects) || '⮩ '}".freeze

    def initialize(log = nil, **params)
      [
        File.join(__dir__, '..', '..', 'config', 'logrithm.yml'),
        (File.join((Rails.root || '.'), 'config', 'logrithm.yml') if Logrithm.rails?)
      ].compact.each do |cfg|
        kungfuig(cfg) if File.exist?(cfg)
      end
      kungfuig(params)
      ensure_logger(log) if log

      @leader = {}
      @colors = {}
    end

    def logger
      ensure_logger
    end

    def flush
      logdev.flush
    end

    def level=(level = nil)
      logger.level = level || case Logrithm.env
                              when :dev, :development, :test then Logger::DEBUG
                              else Logger::INFO
                              end
    end

    INSTANCE = Log.new
    private_class_method :new

    %i(debug info warn error fatal).each do |m|
      define_method(m) do |*args, **extended|
        # rubocop:disable Lint/HandleExceptions
        # rubocop:disable Style/RescueModifier
        unless $♯
          caller_line = caller.detect do |line|
            Logrithm.rails? ? line.start_with?(Rails.root.to_s) : !line.start_with?(__dir__)
          end
          cf = caller_line[/\A(.+):(\d+)(?=:in)/].split(/:(?=\d+\z)/)
          if cf.is_a?(Array) && cf.first.is_a?(String)
            Utils::Syringe.inject(*Utils::Helpers.dirty_lookup_class_method(*cf))
          end
        end rescue nil # SUPPRESS
        # rubocop:enable Style/RescueModifier
        # rubocop:enable Lint/HandleExceptions
        args << $♯ if $♯ # global constant storing the object

        logger.public_send m, (args.length == 1 && extended.empty? ? args.first : [*args, **extended])
      end
    end

    class << self
      def option(*name)
        INSTANCE.option(*name)
      end

      def app_root
        File.realpath(INSTANCE.option(:log, :root) || Logrithm.rails? && Rails.root || File.join(__dir__, '..', '..'))
      end
    end

    private

    def formatter
      begin
        name = option :log, :formatters, Logrithm.env
        Utils::Helpers.constantize name, Logrithm::Formatters
      rescue NameError
        Formatters::Default
      end.formatter
    end

    def logdev
      logger.instance_variable_get(:@logdev).instance_variable_get(:@dev)
    end

    def ensure_logger(log = nil)
      return @log if @log

      @log =  case
              when log then log
              when Logrithm.rails?
                Kernel.const_get('::Rails')
                      .logger
                      .instance_variable_get(:@logger)
                      .instance_variable_get(:@log)
              else
                Logger.new($stderr)
              end

      @tty = @log.respond_to?(:tty?) && @log.tty? ||
             (l = logdev) && l.tty? ||
             Logrithm.rails? && Logrithm.env == :development

      # rubocop:disable Style/ParallelAssignment)
      @formatter, @log.formatter = @log.formatter, formatter
      # rubocop:enable Style/ParallelAssignment)

      self.level = nil

      @log
    end

    def leader(severity)
      @leader[severity] ||= case Logrithm.severity(severity)
                            when 0 then option(:log, :symbols, :debug) || '✓'
                            when 1 then option(:log, :symbols, :info)  || '✔'
                            when 2 then option(:log, :symbols, :warn)  || '✗'
                            when 3 then option(:log, :symbols, :error) || '✘'
                            when 4 then option(:log, :symbols, :fatal) || '∅'
                            else option(:log, :symbols, :debug) || '•'
                            end
    end

    def color(severity)
      @colors[severity] ||= case Logrithm.severity(severity)
                            when 0 then [option(:log, :colors, :debug, :label) || '#747474', option(:log, :colors, :debug, :text) || '#9C9C9C']
                            when 1 then [option(:log, :colors, :info, :label)  || '#FF0000', option(:log, :colors, :info, :text)  || '#6699CC']
                            when 2 then [option(:log, :colors, :warn, :label)  || '#FFFF00', option(:log, :colors, :warn, :text)  || '#FFCC66']
                            when 3 then [option(:log, :colors, :error, :label) || '#AA0000', option(:log, :colors, :error, :text) || '#CC6666']
                            when 4 then [option(:log, :colors, :fatal, :label) || '#FF0000', option(:log, :colors, :fatal, :text) || '#FF0000']
                            else [option(:log, :colors, :debug, :label) || '#747474', option(:log, :colors, :debug, :text) || '#9C9C9C']
                            end.map { |c| Utils::Color.new c }
    end

    def lead(severity, datetime = safe_now)
      " " <<
        color(severity).first.colorize(leader(severity)) <<
        " #{Utils::Output::VB} " <<
        color(:debug).first.colorize(datetime.strftime('%Y%m%d-%H%M%S.%3N')) <<
        " #{Utils::Output::VB} "
    end

    def safe_now
      Time.respond_to?(:zone) ? Time.zone.now : Time.now
    end
  end
end
# rubocop:enable Style/GlobalVars
