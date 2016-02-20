module FileOrganizer
  class UploadJob
    def self.perform_async(*args)
      self.new.perform(*args)
    end

    def perform(guid )

    end

    private
      def tracker

      end
  end
end
