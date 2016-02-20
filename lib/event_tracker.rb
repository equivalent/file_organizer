module FileOrganizer
  class EventTracker
    attr_reader :store_location

    def initialize(store_location)
      @store_location = store_location
    end

    def track(guid:, file:)
      store.transaction do
        store[guid] = file
      end
    end

    private
      def store
        YAML::Store.new('/tmp/loglog.log')
      end
  end
end
