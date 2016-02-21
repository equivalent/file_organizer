require 'spec_helper'

RSpec.describe FileOrganizer::Tracker::YAMLTracker do
  def read_db
    YAML.load(File.read(dbfile_path))
  end

  let(:tracker) { described_class.new(dbfile_path: dbfile_path) }
  let(:dbfile_path) do
    AppTest
      .tmp_test_upload_folder_path
      .join('event.yml')
      .tap { |f| FileUtils.touch f }
  end

  context 'when error' do
    let(:args) do
      {
        processor: 'FileOrganizer::Processor::Dummy',
        guid: '6888888888888888888888888888888d',
        origin_path: Pathname.new('/tmp/source/blabla.tmp'),
        destination_path: Pathname.new('/tmp/destination/blabla.tmp'),
        status: 'error',
        message: 'ErrorKlass: blaa blaa'
      }
    end

    before do
      tracker.track(args)
    end

    it 'not to write anything to store' do
      expect(read_db).to be false # empty yaml file
    end
  end

  context 'when success' do
    let(:args) do
      {
        processor: 'FileOrganizer::Processor::Dummy',
        guid: '6888888888888888888888888888888d',
        origin_path: Pathname.new('/tmp/source/blabla.tmp'),
        destination_path: Pathname.new('/tmp/destination/blabla.tmp'),
        status: 'success',
        message: 'ErrorKlass: blaa blaa'
      }
    end

    before do
      tracker.track(args)
    end

    it 'to write to store under guid files' do
      expect(read_db).to match({
        "6888888888888888888888888888888d" => {
          "files"=>[
            {
              "destination_path"=>"/tmp/destination/blabla.tmp",
              "origin_path"=>"/tmp/source/blabla.tmp",
              "staus"=>"success"
            }
          ]
        }
      })
    end
  end
end
