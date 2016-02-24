require 'aws-sdk'

module FileOrganizer
  module Processor
    class S3Backup
      attr_reader :bucket, :trackers

      def initialize(bucket:, trackers: [] )
        @bucket = bucket
        @trackers = trackers
      end

      def process(document:, guid:, type: 'archive')
        #type = 'aaa'
        #"#{type}/#{guid}/#{document}"

        bucket_resource
          .object(destination(type, guid, document.pathname))
          .upload_file(document.pathname.to_s)

        #bbb = destination_guid_folder(guid: guid).join('blaaa')
      end

      private

      # modularrize
      def destination(type, guid, origin_path)
        "#{type}/#{guid}/#{sanitize(origin_path.basename)}"
      end

      private
        def bucket_resource
          @bucket_resource = Aws::S3::Bucket.new(bucket)
        end

        def sanitize(name)
          name.to_s.gsub(/[^0-9A-Za-z.\-_]/,'')
        end
    end
  end
end
