module FileOrganizer
  module Processor
    class LocalBackup
      attr_reader :destination

      def initialize(destination:)
        @destination = destination
      end

      def process(document:, guid:)
        prepare_destination(guid: guid)
        copy_to_destination(document: document, guid: guid)
      end

      private
        def copy_to_destination(document:, guid:)
          dfn = destination_filename(document: document, guid: guid)
          begin
            FileUtils.cp(document.pathname, dfn)
            # success
          rescue Errno::ENOENT => e
            raise e
            # error e
          end
        end

        def destination_filename(guid:, document:)
          destination_guid_folder(guid:guid)
            .join(sanitize(document.pathname.basename))
        end

        def prepare_destination(guid:)
          FileUtils.mkdir_p(destination_guid_folder(guid: guid))
        end

        def destination_guid_folder(guid:)
          Pathname
            .new(destination)
            .join(guid)
        end

        def sanitize(name)
          name.to_s.gsub(/[^0-9A-Za-z.\-_]/,'')
        end
    end
  end
end
