module Logrithm
  module Utils
    module Helpers
      class << self
        def constantize(string, namespace = Kernel)
          namespace = Kernel.const_get(namespace) unless namespace.is_a?(Module)
          result = namespace.const_get string.to_s.gsub(/(?:\A|_)(\w)/) { |m| m[-1].upcase }
          result if namespace == Kernel || result.to_s =~ /\A#{namespace}/
        rescue NameError
          nil
        end

        def dirty_lookup_class_method(file, lineno)
          content = File.readlines(file)[0..lineno.to_i].reverse
          result = content.each_with_object(method: nil, ns: []) do |line, memo|
            (memo[:method] ||= line[/\A\s*def\s*(?<method>\w+)/, :method]) &&
              (memo[:ns] << line[/\A\s*(?:class|module)\s*(?<ns>\w+)/, :ns])
          end

          [const_get(result[:ns].compact.reverse.join('::')), result[:method]]
        end
      end
    end
  end
end
