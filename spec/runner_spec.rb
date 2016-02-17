require 'spec_helper'

RSpec.describe Runner do
  def set_size
    Dir
      .glob(root_folder.join('*'))
      .size
  end

  let(:root_folder) { AppTest.tmp_test_root_path }

  before do
    subject.folder = root_folder
    subject.sets_size = 3
    subject.run
  end

  it do
    expect(set_size).to be 3
  end

end
