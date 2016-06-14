begin
  require 'rack/cache'
rescue LoadError
  puts "Couldn't find rack-cache - make sure you have it in your Gemfile:"
  puts "  gem 'rack-cache', require: 'rack/cache'"
end

module Logrithm
  module Middleware
    class Rack
      MAXREADLEN = 2048

      def initialize(app, logger)
        # rubocop:disable Style/ParallelAssignment
        @app, @logger = app, logger
        # rubocop:enable Style/ParallelAssignment
        @rp, @wp = IO.pipe

        Thread.new do
          loop do
            begin
              ✍ @rp.read_nonblock(MAXREADLEN)
            rescue IO::WaitReadable
              IO.select([@rp])
              retry
            end
          end
        end
      end

      def call(env)
        IO.select(nil, [env['rack.errors'] = @wp])
        @app.call(env)
      end

      # rubocop:disable Style/MethodName
      # rubocop:disable Style/OpMethod
      def ✍(what)
        Logrithm.debug what unless what.blank?
      end
      # rubocop:enable Style/OpMethod
      # rubocop:enable Style/MethodName
    end
  end
end

Rails.application.middleware
     .insert_before Rack::Cache, Logrithm::Middleware::Rack, :logrithm if Logrithm.rails?
