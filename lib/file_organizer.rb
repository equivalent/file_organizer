require 'yaml'
require 'pathname'
require 'forwardable'

require 'file_organizer/version'
require 'file_organizer/config'
require 'file_organizer/folder'
require 'file_organizer/document'
require 'file_organizer/set'
require 'file_organizer/runner'
require 'file_organizer/jobs/upload_job'

Dir
  .glob("#{File.dirname(__FILE__)}/file_organizer/processor/helper_object/*.rb")
  .each { |file| require file }

Dir
  .glob("#{File.dirname(__FILE__)}/file_organizer/processor/*.rb")
  .each { |file| require file }

Dir
  .glob("#{File.dirname(__FILE__)}/file_organizer/tracker/*.rb")
  .each { |file| require file }

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
