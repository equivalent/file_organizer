require 'yaml'
require 'yaml/store'
require 'pathname'
require 'forwardable'

require 'file_organizer/version'
require 'file_organizer/config'
require 'file_organizer/folder'
require 'file_organizer/document'
require 'file_organizer/set'
require 'file_organizer/runner'
require 'file_organizer/jobs/upload_job'
require 'file_organizer/processor/local_backup'

module FileOrganizer
  class << self
    def config=(cfg)
      @config = cfg
    end

    def config
      @config ||= Config.new
    end
  end
end
