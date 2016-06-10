# rubocop:disable Style/GlobalVars
module Logrithm
  module Utils
    module Syringe
      class << self
        def inject(*km)
          return unless km.size == 2 && km.first.is_a?(Class) && km.last.is_a?(String)
          klazz, method = km

          name = scramble "Logrithm@#{klazz}##{method}"
          return if klazz.ancestors.map(&:name).include? "Kernel::#{name}"

          Kernel.const_set(
            name,
            Module.new do
              define_method method do |*args|
                $♯ = self
                super(*args)
              end
            end
          )
          klazz.prepend Kernel.const_get name
        end

        def scramble(str)
          str.gsub(/[:#@?!]/, ':' => '：', '#' => '＃', '@' => '＠', '?' => '？', '!' => '！', '=' => '＝')
        end
      end
    end
  end
end
# rubocop:enable Style/GlobalVars
