require 'aws-sdk'

module FileOrganizer
  module Processor
    class S3Backup
      attr_reader :bucket, :trackers

      def initialize(bucket:, trackers: [] )
        @bucket = bucket
        @trackers = trackers
      end

      def process(source_path:, guid:, type:, **other_options)
        begin
          destination_name = destination(type, guid, source_path)

          sanitized_name = FileOrganizer::Processor::HelperObject::UniqueName
            .new(existence_determiner: S3FileExistanceDeterminer.new(bucket_resource: bucket_resource) )
            .sanitize(destination_name)

          bucket_object(destination_name).upload_file(sanitized_name)
        rescue Seahorse::Client::NetworkingError
          puts "retrying"
          sleep 10
          retry
        end
      end

      class S3FileExistanceDeterminer
        attr_reader :bucket_resource

        def initialize(bucket_resource:)
          @bucket_resource = bucket_resource
        end

        def call(location)
          bucket_resource.object(location).exists?
        end
      end

      private

        def existance_determiner

        end

        def bucket_object(location)
          bucket_resource.object(location)
        end

        # modularrize
        def destination(type, guid, origin_path)
          "#{type}/#{guid}/#{sanitize(origin_path.basename)}"
        end

        def bucket_resource
          @bucket_resource ||= Aws::S3::Bucket.new(bucket)
        end

        def sanitize(name)
          name.to_s.gsub(/[^0-9A-Za-z.\-_]/,'')
        end
    end
  end
end
