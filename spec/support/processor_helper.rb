module FileOrganizer
  module AppTest
    module ProcessorHelper
      def trigger
        processor.process(document: document, guid: guid)
      end
    end
  end
end
