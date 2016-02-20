$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'file_organizer'
require 'fileutils'
#require 'secure_random'

module AppTest
  def self.test_root_path
    Pathname.new(File.expand_path('../support/test_root_path', __FILE__))
  end

  def self.tmp_test_root_path
    Pathname.new(File.expand_path('../../tmp/test_root_path', __FILE__))
  end

  def self.tmp_test_tracker_file
    Pathname.new(File.expand_path('../../tmp/test/foobar.yml', __FILE__)).to_s
  end
end

#FileOrganizer.config.root_file = AppTest.tmp_test_root_folder

RSpec.configure do |config|
  config.before(:each) do
    FileUtils.mkdir_p(AppTest.tmp_test_root_path)
  end

  config.after(:each) do
    FileUtils.rm_r Dir.glob(AppTest.tmp_test_root_path)
  end
end
