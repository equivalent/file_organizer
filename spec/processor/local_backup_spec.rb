require 'spec_helper'

RSpec.describe FileOrganizer::Processor::LocalBackup do
  def destination_files
    Dir.glob(destination.join('*/**/*')) # all inside guid folder (similar to */** but
                                         # without guid_folder in list)
  end

  def trigger
    processor.process(document: document, guid: guid)
  end

  let(:processor) { described_class.new(destination: destination) }
  let(:destination) { AppTest.tmp_test_upload_folder_path }
  let(:guid) { '6eaec6511eec985c9614d97d2d03252d' }

  let(:tracker1) { spy }
  let(:tracker2) { spy }

  before do
    processor.trackers << tracker1
    processor.trackers << tracker2
  end

  describe '#process' do
    context 'when file with special chars in name' do
      let(:document) do
        path = AppTest.test_root_path.join(guid, %q{wierd#'ame.xyz.txt})
        double(pathname: path)
      end

      let(:destination_file) do
        Pathname
          .new(destination)
          .join('6eaec6511eec985c9614d97d2d03252d')
          .join('wierdame.xyz.txt')
          .to_s
      end

      it 'will rename file without special chars' do
        expect(destination_files).not_to include(destination_file)
        trigger
        expect(destination_files).to include(destination_file)
      end

      it 'should notify trackers' do
        trigger

        expect(tracker1)
          .to have_received(:track)
          .with({
            guid: '6eaec6511eec985c9614d97d2d03252d',
            origin_path: document.pathname,
            destination_path: Pathname.new(destination_file),
            status: 'success',
            message: nil
          })

        expect(tracker2)
          .to have_received(:track)
          .with({
            guid: '6eaec6511eec985c9614d97d2d03252d',
            origin_path: document.pathname,
            destination_path: Pathname.new(destination_file),
            status: 'success',
            message: nil
          })
      end
    end

    context 'when file nested in a folder' do
      let(:document) do
        path = AppTest.test_root_path.join(guid, 'folder', 'folder', 'hello world .txt')
        double(pathname: path)
      end

      let(:destination_file) do
        Pathname
          .new(destination)
          .join('6eaec6511eec985c9614d97d2d03252d')
          .join('helloworld.txt')
          .to_s
      end

      it 'will upload file to root of the destination folder' do
        expect(destination_files).not_to include(destination_file)
        trigger
        expect(destination_files).to include(destination_file)
      end
    end

    context 'when file with same name exist already' do
      let(:document) do
        path = AppTest.test_root_path.join(guid, 'blabla.txt')
        double(pathname: path)
      end

      let(:destination_file) do
        Pathname
          .new(destination)
          .join('6eaec6511eec985c9614d97d2d03252d')
          .join('blabla-1.txt')
          .to_s
      end

      let(:destination_file2) do
        Pathname
          .new(destination)
          .join('6eaec6511eec985c9614d97d2d03252d')
          .join('blabla-2.txt')
          .to_s
      end

      before do
        FileUtils.touch Pathname
          .new(destination)
          .join('6eaec6511eec985c9614d97d2d03252d')
          .tap { |path| FileUtils.mkdir_p(path) }
          .join('blabla.txt')
      end

      it 'should generate file with sufix' do
        expect(destination_files.size).to be 1
        trigger
        expect(destination_files.size).to be 2
        expect(destination_files).to include(destination_file)
        trigger
        expect(destination_files.size).to be 3
        expect(destination_files).to include(destination_file2)
      end
    end

    context 'there was error' do
      let(:document) do
        path = AppTest.test_root_path.join(guid, 'blabla.txt')
        double(pathname: path)
      end

      let(:destination_file) do
        Pathname
          .new(destination)
          .join('6eaec6511eec985c9614d97d2d03252d')
          .join('blabla.txt')
          .to_s
      end

      before do
        allow(FileUtils)
          .to receive(:cp)
          .and_raise(Errno::ENOENT)
      end

      it 'not to copy the file' do
        trigger
        expect(destination_files).to be_empty
      end

      it 'should notify trackers with errors' do
        trigger

        expect(tracker1)
          .to have_received(:track)
          .with({
            guid: '6eaec6511eec985c9614d97d2d03252d',
            origin_path: document.pathname,
            destination_path: Pathname.new(destination_file),
            status: 'error',
            message: 'Errno::ENOENT: No such file or directory'
          })

        expect(tracker2)
          .to have_received(:track)
          .with({
            guid: '6eaec6511eec985c9614d97d2d03252d',
            origin_path: document.pathname,
            destination_path: Pathname.new(destination_file),
            status: 'error',
            message: 'Errno::ENOENT: No such file or directory'
          })
      end
    end
  end
end
