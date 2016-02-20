module FileOrganizer
  class Config
    attr_writer :root_file,
      :event_tracker_store_location

    def root_path
      Pathname.new(root_file)
    end

    def project_root
      Pathname.new(File.expand_path('../../../', __FILE__))
    end

    def template_folder
      project_root.join('template')
    end

    def event_tracker_store_location
      @event_tracker_store_location || root_path.join('tmp', 'event_tracker.yml')
    end

    def event_tracker_klass
      FileOrganizer::EventTracker
    end

    private
      attr_reader :root_file
  end
end
