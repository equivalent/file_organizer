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
          FileUtils.cp(document.pathname, dfn)
        end

        def destination_filename(guid:, document:)
          destination_guid_folder(guid:guid)
            .join(document.pathname)
        end

        def prepare_destination(guid:)
          FileUtils.mkdir_p(destination_guid_folder(guid: guid))
        end

        def destination_guid_folder(guid:)
          Pathname
            .new(destination)
            .join(guid)
        end
    end
  end
end
