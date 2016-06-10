require 'logger'
require 'io/console'

# rubocop:disable Style/GlobalVars
module Logrithm
  class Log
    include Kungfuig

    def self.log(message)
      if $♯
        puts "Self: [#{$♯}], Message: [#{message}]."
      else
        # idx = caller.index { |s| s.include? __FILE__ } to work inside pry
        Utils::Syringe.inject(*Utils::Helpers.dirty_lookup_class_method(*caller.first[/\A(.+):(\d+)(?=:in)/].split(/:(?=\d+\z)/)))
        puts "Message: [#{message}]."
      end
    rescue
      puts "Message: [#{message}]."
    end

    def initialize(log = nil, **params)
      [
        File.join(__dir__, '..', '..', 'config', 'logrithm.yml'),
        (File.join(Rails.root, 'config', 'logrithm.yml') if Logrithm.rails?)
      ].compact.each do |cfg|
        kungfuig(cfg) if File.exist?(cfg)
      end
      kungfuig(params)
      ensure_logger(log) if log
    end

    def logger
      ensure_logger
    end

    INSTANCE = Log.new
    private_class_method :new

    private

    def formatter
      begin
        name = option :log, :formatters, Logrithm.env
        Utils::Helpers.constantize name, Logrithm::Formatters
      rescue NameError
        Formatters::Default
      end.formatter
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
                Logger.new($stdout)
              end

      @tty = @log.respond_to?(:tty?) && @log.tty? ||
             (l = @log.instance_variable_get(:@logdev)
                      .instance_variable_get(:@dev)) && l.tty? ||
             Logrithm.rails? && Logrithm.env == :development

      # rubocop:disable Style/ParallelAssignment)
      @formatter, @log_formatter = @log.formatter, formatter
      # rubocop:enable Style/ParallelAssignment)

      @log
    end
  end
end
# rubocop:enable Style/GlobalVars
