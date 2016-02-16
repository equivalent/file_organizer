module FileOrganizer
  class Config
    attr_writer :root_file

    def root_path
      Pathname.new(root_file)
    end

    def project_root
      Pathname.new(File.expand_path('../../../', __FILE__))
    end

    def template_folder
      project_root.join('template')
    end

    private
      attr_reader :root_file
  end
end
