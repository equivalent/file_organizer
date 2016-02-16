require 'spec_helper'

RSpec.describe Set do
  context 'read' do
    let(:guid) { '6eaec6511eec985c9614d97d2d03252d' }

    before do
      subject.folder = AppTest.test_root_path
      subject.guid = guid
    end

    it 'should have set_type' do
      # archive, photo
      expect(subject.type).to eq 'archive'
    end

    it 'should have uploaded_at'

    it 'should have guid' do
      expect(subject.guid).to be_kind_of String
      expect(subject.guid.length).to eq 32
    end

    it 'should have files' do
      expect(subject.files).to be_kind_of Array
      expect(subject.files.size).to be 3
    end

    describe '#upload_ready' do
      context 'when descripion.yml say no' do
        it do
          expect(subject.upload_ready).to be false
        end
      end

      context 'when descripion.yml say yes' do
        let(:guid) { '6666upload_ready_123412341' }

        it do
          expect(subject.upload_ready).to be true
        end
      end
    end

    describe '#upload_blacklist' do
      it do
        expect(subject.upload_blacklist).to eq([
          'description.yml',
          '.file_orginizer_delete_ready',
          '.file_orginizer_lock'
        ])
      end
    end

    describe '#delete_ready' do
      it do
        expect(subject.delete_ready).to be false
      end
    end

    describe '#upstream_json' do
      it do
        expect(subject.upstream_json).to match({
          title: 'This is awesome title',
          description: 'bla bla some description',
          type: 'archive',
          guid: subject.guid
        })
      end
    end
  end

  context 'prepared' do
    before do
      subject.folder = AppTest.tmp_test_root_path
      subject.prepare
    end

    it 'should create description.yml' do
      file = AppTest.tmp_test_root_path.join(subject.guid, 'description.yml')
      expect(File.exist?(file)).to be true
    end
  end


  context 'when ready description.yml changes to upload_ready=true' do
    it 'should have upload ready true'
    it 'should have delete ready false'
  end

  describe '#prepare set folder' do
    it 'should create root_path/type/guid/ folder'
    it 'should create description.yml'
  end

end
