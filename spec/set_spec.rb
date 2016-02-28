require 'spec_helper'

RSpec.describe FileOrganizer::Set do
  describe '.detect_existing' do
    let(:root_folder) { AppTest.test_root_path }
    subject { described_class.detect_existing(root_folder) }

    it 'should locate sets' do
      expect(subject.size).to be 3
      expect(subject.map(&:guid)).to eq([
        '6eaec6511eec985c9614d97d2d03252d',
        '6666upload_ready_123412341',
        '777_locked_12345'
      ])
    end
  end

  context 'read' do
    let(:guid) { '6eaec6511eec985c9614d97d2d03252d' }

    before do
      subject.folder = AppTest.test_root_path
      subject.guid = guid
    end

    context do
      it { expect(subject.type).to eq 'archive' }
    end

    context do
      let(:guid) { '6666upload_ready_123412341' }
      it { expect(subject.type).to eq 'photo' }
    end

    describe "#date" do
      it do
        expect(subject.date).to eq Date.parse('2016-02-18')
      end
    end

    it 'should have guid' do
      expect(subject.guid).to be_kind_of String
      expect(subject.guid).to eq guid
    end

    describe '#valid?' do
      context 'if it has description.yml' do
        it { expect(subject).to be_valid }
      end

      context "if it doesn't have description.yml" do
        let(:guid) { 'not_valid_set_folder' }

        it { expect(subject).not_to be_valid }
      end
    end

    describe '#files' do
      context do
        it 'should have files' do
          expect(subject.files).to be_kind_of Array
          expect(subject.files.size).to be 6
        end
      end

      context do
        let(:guid) { '6666upload_ready_123412341' }

        it 'should have files' do
          expect(subject.files).to be_kind_of Array
          expect(subject.files.size).to be 2
          expect(subject.files.last.basename.to_s).to eq 'image asset.jpg'
        end
      end

      context do
        let(:guid) { '777_locked_12345' }

        it 'should have files' do
          expect(subject.files).to be_kind_of Array
          expect(subject.files.size).to be 2
        end

        it do
          expect(subject.files.last.basename.to_s).to eq 'hello-world.md'
        end

        it do
          expect(subject.files.first.basename.to_s).to eq 'description.yml'
        end
      end
    end

    describe '#locked?' do
      it do
        expect(subject.locked?).to be false
      end

      context do
        let(:guid) { '777_locked_12345' }

        it do
          expect(subject.locked?).to be true
        end
      end
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

      context 'when descripion.yml say yes but locked?' do
        let(:guid) { '777_locked_12345' }

        it do
          expect(subject.upload_ready).to be false
        end
      end
    end

    describe '#delete_ready' do
      it do
        expect(subject.delete_ready).to be false
      end

      context 'when descripion.yml say yes' do
        let(:guid) { '6666upload_ready_123412341' }
        it { expect(subject.delete_ready).to be false }
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

    it 'should gennerate guid' do
      expect(subject.guid).to be_kind_of String
      expect(subject.guid.length).to eq 32
    end

    it 'should create description.yml' do
      file = AppTest.tmp_test_root_path.join(subject.guid, 'description.yml')
      expect(File.exist?(file)).to be true
    end

    describe '#locked?' do
      it do
        expect(subject.locked?).to eq false
        subject.lock
        expect(subject.locked?).to eq true
      end
    end
  end
end
