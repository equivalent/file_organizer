require 'aws-sdk'

module FileOrganizer
  module Processor
    class S3Backup
      attr_reader :bucket, :region, :trackers

      def initialize(region:,bucket:, trackers: [] )
        @bucket = bucket
        @region = region  # e.g. 'eu-west-1'
        @trackers = trackers
      end

      def process(document:, guid:)
        obj = bucket.object('guid/blabla.txt')
        obj.upload_file(destination_guid_folder(guid: guid).join('blaaa'))
      end

      # modularrize
      def destination_guid_folder(guid:)
        Pathname
          .new(destination)
          .join(guid)
      end

      private
        def bucket_resource
          @bucket_resource = Aws::S3::Resource
            .new(region)
            .bucket('bucket')
        end

    end
  end
end
