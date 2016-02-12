require 'file_organizer/version'
require 'file_organizer/config'
require 'pathname'

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
