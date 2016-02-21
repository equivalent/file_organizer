require 'spec_helper'

RSpec.describe FileOrganizer::Processor::LocalBackup do
  def destination_files
    Dir.glob(destination.join('*/**/*')) # all inside guid folder (similar to */** but
                                         # without guid_folder in list)
  end

  let(:processor) { described_class.new(destination: destination) }
  let(:destination) { AppTest.tmp_test_upload_folder_path }
  let(:guid) { '6eaec6511eec985c9614d97d2d03252d' }
  let(:document) do
    path = AppTest.test_root_path.join(guid, %q{wierd#'ame.xyz.txt})
    double(pathname: path)
  end

  let(:trigger) { processor.process(document: document, guid: guid) }

  describe '#process' do
    it do
      fn = Pathname
        .new(destination)
        .join('6eaec6511eec985c9614d97d2d03252d', 'wierdame.xyz.txt')

      expect(fn).not_to be_exist
      trigger

      expect(destination_files).to include(fn.to_s)
    end
  end
end
