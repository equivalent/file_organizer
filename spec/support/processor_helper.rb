module FileOrganizer
  module AppTest
    module ProcessorHelper
      def trigger
        processor.process(source_path: source_path, guid: guid, type: type)
      end
    end
  end
end
