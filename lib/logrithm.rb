require 'kungfuig'

require 'logrithm/version'
require 'logrithm/utils/color'
require 'logrithm/utils/helpers'

require 'logrithm/formatters'

require 'logrithm/utils/syringe'

module Logrithm
  def rails?
    Kernel.const_defined?('::Rails')
  end
  module_function :rails?

  def env
    case
    when ENV['LOGRITHM_ENV'] then ENV['LOGRITHM_ENV'].to_sym
    when rails? then Rails.env
    else :development
    end
  end
  module_function :env

  def severity(severity)
    case severity.to_s.upcase
    when 'DEBUG', '0' then 0
    when 'INFO',  '1' then 1
    when 'WARN',  '2' then 2
    when 'ERROR', '3' then 3
    when 'FATAL', '4' then 4
    else 2
    end
  end
  module_function :severity
end

require 'logrithm/log'
require 'logrithm/utils/output'
require 'logrithm/utils/airslack'
require 'logrithm/spitters'

# This require is to be put into Rails initializer
# require 'logrithm/middleware/rack'

module Logrithm
  class << self
    %i(debug info warn error fatal).each do |m|
      define_method(m) do |*args, **extended|
        Logrithm::Log::INSTANCE.public_send m, *args, **extended
      end
    end

    def color(severity)
      Log::INSTANCE.send(:color, severity)
    end
  end
end
