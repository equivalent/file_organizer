module FileOrganizer
  module Processor
    module HelperObject
      class UniqueName
        attr_reader :existence_determiner

        def initialize(existence_determiner:)
          @existence_determiner = existence_determiner
        end

        def sanitize(name)
          non_duplicate_name(sanitized_name(name))
        end

        private
          def sanitized_name(name)
            name.to_s.gsub(/[^0-9A-Za-z.\-_\/]/,'')
          end

          def non_duplicate_name(name, suffix: nil)
            if suffix
              generated_name = generate_name(name, suffix: suffix)
            else
              generated_name = name
            end

            if existence_determiner.call(generated_name)
              non_duplicate_name(name, suffix: suffix.to_i + 1)
            else
              generated_name
            end
          end

          def generate_name(name, suffix: )
            pathname = Pathname.new(name)
            pathname.sub_ext('').to_s + "-#{suffix.to_i}" + pathname.extname.to_s
          end
      end
    end
  end
end
