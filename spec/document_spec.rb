require 'spec_helper'

RSpec.describe FileOrganizer::Document do
  let(:guid_folder)  { AppTest.test_root_path.join('777_locked_12345')  }
  let(:set)          { instance_double FileOrganizer::Set, guid: '777_locked_12345', type: 'archive' }
  subject(:document) { described_class.new(raw_file: raw_file, set: set) }

  describe '.upload_blacklist' do
    it do
      expect(described_class.upload_blacklist).to eq([
        'description.yml',
        '.file_organizer_lock'
      ])
    end
  end

  describe '#qualify_for_upload?' do
    context 'given description.yml' do
      let(:raw_file) { guid_folder.join('description.yml').to_s }
      it { expect(subject.qualify_for_upload?).to be false }
    end

    context 'given regular file' do
      let(:raw_file) { guid_folder.join('hello-world.md').to_s }
      it { expect(subject.qualify_for_upload?).to be true }
    end

    context 'given .file_organizer_lock' do
      let(:raw_file) { guid_folder.join('.file_organizer_lock').to_s }
      it { expect(subject.qualify_for_upload?).to be false }
    end
  end

  describe '#process' do
    context 'given regular file' do
      let(:raw_file) { guid_folder.join('hello-world.md').to_s }
      let(:dummy_processor1) { spy }
      let(:dummy_processor2) { spy }

      before do
        expect(document)
          .to receive(:processors)
          .and_return([dummy_processor1, dummy_processor2])

        document.process
      end

      it do
        expect(dummy_processor1).to have_received(:process)
        expect(dummy_processor2).to have_received(:process)
      end
    end
  end

  describe '#pathname' do
    let(:raw_file) { guid_folder.join('hello-world.md').to_s }

    it do
      expect(subject.pathname).to be_kind_of(Pathname)
      expect(subject.pathname).to eq guid_folder.join('hello-world.md')
    end
  end
end
