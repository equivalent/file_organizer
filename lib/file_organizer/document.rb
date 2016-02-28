module FileOrganizer
  class Document
    extend Forwardable

    attr_reader :set
    def_delegator :pathname, :basename
    def_delegators :set, :guid, :type

    def self.upload_blacklist
      %w(.file_organizer_lock)
    end

    def initialize(raw_file:, set:)
      @raw_file = raw_file
      @set      = set
    end

    def pathname
      Pathname.new(raw_file)
    end

    def is_description_file
      pathname.basename.to_s == 'description.yml'
    end

    def qualify_for_upload?
      !(self.class.upload_blacklist).include?(basename.to_s)
    end

    def process
      processors.each do |u|
        u.process(source_path: pathname, guid: guid, type: type)
      end
    end

    def processors
      FileOrganizer.config.uploaders
    end

    private
      attr_reader :raw_file
  end
end
