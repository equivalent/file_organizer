module FileOrganizer
  module Tracker
    class LogTracker
      attr_reader :logger, :level

      def initialize(logger:, level: :info)
        @logger = logger
        @level  = level
      end

      def track(processor:, guid:, origin_path:, destination_path:, status:, message:)
        msg = "Processing with #{processor} " +
          "resulted with #{status}; " +
          "message: '#{message}' " +
          "origin: #{origin_path.to_s} " +
          "destination: #{destination_path.to_s} " +
          "guid: #{guid}"
        logger.send(level, msg)
      end
    end
  end
end
