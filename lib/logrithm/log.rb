# rubocop:disable Style/GlobalVars
module Logrithm
  class Log
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
  end
end
# rubocop:enable Style/GlobalVars
