require 'spec_helper'

RSpec.describe Runner do
  def guid_folders_size
    Dir
      .glob(root_folder.join('*'))
      .size
  end

  let(:root_folder) { AppTest.tmp_test_root_path }

  context 'set size is set to 3' do
    let(:trigger) { subject.run }

    before do
      subject.folder = root_folder
      subject.sets_size = 3
    end

    context 'no guid folder exists' do
      it 'should generate 3 guid folders' do
        expect { trigger }
          .to change { guid_folders_size }
          .from(0)
          .to(3)
      end
    end

    context 'given 1 guid folder exist' do
      it 'should generate 2 guid folders' do
        #FileUtils.touch(root_folder.join('should_ignore_files.txt'))
        #FileUtils.mkdir(root_folder.join('should_ignore_folders_without_description'))

        FileUtils
          .mkdir(root_folder.join('should_not_ignore_this_folder'))
          .tap { |ary| FileUtils.touch(Pathname.new(ary.first).join('description.yml')) }

        expect { trigger }
          .to change { guid_folders_size }
          .from(1)
          .to(3)
      end
    end
  end
end
