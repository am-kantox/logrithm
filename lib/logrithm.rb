require 'kungfuig'

require 'logrithm/version'
require 'logrithm/utils/color'
require 'logrithm/utils/helpers'
require 'logrithm/utils/output'

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
    case severity
    when :debug, 'debug', 'DEBUG', '0', 0 then 0
    when :info,  'info',  'INFO',  '1', 1 then 1
    when :warn,  'warn',  'WARN',  '2', 2 then 2
    when :error, 'error', 'ERROR', '3', 3 then 3
    when :fatal, 'fatal', 'FATAL', '4', 4 then 4
    else 2
    end
  end
  module_function :severity
end

require 'logrithm/log'

require 'logrithm/middleware/rack'
