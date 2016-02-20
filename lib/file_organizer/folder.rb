module FileOrganizer
  module Folder
    def self.included(base)
      base.send(:attr_writer, :folder)
    end

    def folder
      @folder || FileOrganizer.config.root_path
    end
  end
end
