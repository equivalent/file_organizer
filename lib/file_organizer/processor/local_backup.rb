module FileOrganizer
  module Processor
    class LocalBackup
      attr_reader :destination, :trackers

      def initialize(destination:, trackers: [])
        @destination = destination
        @trackers = trackers
      end

      def process(document:, guid:)
        prepare_destination(guid: guid)
        copy_to_destination(document: document, guid: guid)
      end

      private
        def copy_to_destination(document:, guid:)
          dfn = destination_path(document: document, guid: guid)
          begin
            FileUtils.cp(document.pathname, dfn)
            status = 'success'
            message = nil
          rescue Errno::ENOENT => e
            status = 'error'
            message = "#{e.class}: #{e.to_s}"
          end

          notify_trackers({
            processor: self.class.to_s,
            guid: guid,
            origin_path: document.pathname,
            destination_path: dfn,
            status: status,
            message: message
          })
        end

        def destination_path(guid:, document:)
          guid_path = destination_guid_folder(guid:guid)

          sanitized_name = FileOrganizer::Processor::HelperObject::UniqueName
            .new(existence_determiner: LocalFileExistanceDeterminer.new(guid_path: guid_path) )
            .sanitize(document.pathname.basename)

          guid_path.join(sanitized_name)

          #non_duplicate_path(name: sanitized_name, guid_path: guid_path)
        end

        class LocalFileExistanceDeterminer
          attr_reader :guid_path

          def initialize(guid_path:)
            @guid_path = guid_path
          end

          def call(name)
            File.exist?(guid_path.join(name))
          end
        end

        def prepare_destination(guid:)
          FileUtils.mkdir_p(destination_guid_folder(guid: guid))
        end

        def destination_guid_folder(guid:)
          Pathname
            .new(destination)
            .join(guid)
        end

        #def generate_name(name:, suffix: )
          #pathname = Pathname.new(name)
          #pathname.sub_ext('').to_s + "-#{suffix.to_i}" + pathname.extname.to_s
        #end

        #def non_duplicate_path(name:, guid_path:, suffix: nil)
          #if suffix
            #file_path = guid_path.join(generate_name(name: name, suffix: suffix))
          #else
            #file_path = guid_path.join(name)
          #end

          #if File.exist?(file_path)
            #non_duplicate_path(name: name, guid_path: guid_path, suffix: suffix.to_i + 1)
          #else
            #file_path
          #end
        #end

        def notify_trackers(*args)
          trackers.each do |tracker|
            tracker.track(*args)
          end
        end
    end
  end
end
