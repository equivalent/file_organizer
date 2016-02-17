require 'spec_helper'

class Runner
  attr_reader :sets
  attr_accessor :folder, :sets_size

  def initialize
    @sets = []
  end

  def run
    # find_sets
    (sets_size - sets.size).times do
      sets << prepare_set
    end
  end

  private
    def prepare_set
      Set.new
        .tap { |s| s.folder = folder }
        .tap { |s| s.prepare }
    end

end

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
