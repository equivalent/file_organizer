module FileOrganizer
  class Document
    extend Forwardable

    attr_reader :guid
    def_delegator :pathname, :basename

    def self.upload_blacklist
      %w(description.yml .file_organizer_lock)
    end

    def initialize(raw_file:, guid:)
      @raw_file = raw_file
      @guid     = guid
    end

    def pathname
      Pathname.new(raw_file)
    end

    def qualify_for_upload?
      !(self.class.upload_blacklist).include?(basename.to_s)
    end

    def process
      processors.each do |u|
        u.process(document: self, guid: guid)
      end
    end

    def processors
      FileOrganizer.config.uploaders
    end

    private
      attr_reader :raw_file
  end
end
