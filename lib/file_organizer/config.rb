module FileOrganizer
  class Config
    attr_writer :root_file

    def root_path
      Pathname.new(root_file)
    end

    private
      attr_reader :root_file
  end
end
