require 'spec_helper'
RSpec.describe FileOrganizer::Config do
  before do
    @old_config = FileOrganizer.config
    FileOrganizer.config = FileOrganizer::Config.new
  end

  after do
    FileOrganizer.config = @old_config
  end

  describe '#template_folder' do
    it  do
      expect(subject.template_folder.to_s).to match('file_organizer/template')
    end
  end

  describe '#root_path' do
    subject { FileOrganizer.config.root_path }

    before do
      FileOrganizer.config.root_file = '/tmp/bla'
    end

    it 'to be Pathname object' do
      expect(subject).to be_kind_of Pathname
    end

    it 'to be folder I specified' do
      expect(subject.to_s).to eq '/tmp/bla'
    end
  end
end
