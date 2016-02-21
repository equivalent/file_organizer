require 'yaml/store'

module FileOrganizer
  module Tracker
    class YAMLTracker
      attr_reader :dbfile_path

      def initialize(dbfile_path:)
        @dbfile_path = dbfile_path
      end

      def track(processor:, guid:, origin_path:, destination_path:, status:, message:)
        if status == 'success'
          store.transaction do
            store[guid] ||= {}
            store[guid]['files'] ||= []
            store[guid]['files'] << {
              'destination_path' => destination_path.to_s,
              'origin_path' => origin_path.to_s,
              'staus' => status
            }
          end
        end
      end

      private
        def store
          @store ||= YAML::Store.new(dbfile_path.to_s)
        end
    end
  end
end
