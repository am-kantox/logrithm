$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'logrithm'
require 'pry'

module TestNS1
  module TestNS2
    class Test
      def test_log
        Logrithm::Log.log "Hey, dude!"
      end
    end
  end
end
