$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'logrithm'
require 'pry'

module TestNS1
  module TestNS2
    class Test
      def inspect
        "Self: #{super}"
      end

      def test_log
        Logrithm.debug "Hey, dude!"
      end
    end
  end
end
