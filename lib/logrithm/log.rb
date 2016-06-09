# rubocop:disable Style/GlobalVars
module Logrithm
  class Log
    def self.log(message)
      if $♯
        puts "Self: [#{$♯}], Message: [#{message}]."
      else
        # idx = caller.index { |s| s.include? __FILE__ } to work inside pry
        Syringe.inject(*dirty_get(*caller.first[/\A(.+):(\d+)(?=:in)/].split(/:(?=\d+\z)/)))
        puts "Message: [#{message}]."
      end
    rescue
      puts "Message: [#{message}]."
    end

    def self.dirty_get(file, lineno)
      content = File.readlines(file)[0..lineno.to_i].reverse
      result = content.each_with_object(method: nil, ns: []) do |line, memo|
        (memo[:method] ||= line[/\A\s*def\s*(?<method>\w+)/, :method]) &&
          (memo[:ns] << line[/\A\s*(?:class|module)\s*(?<ns>\w+)/, :ns])
      end

      [const_get(result[:ns].compact.reverse.join('::')), result[:method]]
    end
  end
end
# rubocop:enable Style/GlobalVars
