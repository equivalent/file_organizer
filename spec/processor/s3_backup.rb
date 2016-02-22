require 'spec_helper'
RSpec.describe FileOrganizer::Processor::S3Backup do
  let(:processor) { described_class.new(region: 'eu-west-1', bucket: 'foobarbucket') }
  let(:trigger) { }

  before do
    AWS.stub!
  end

  it do


  end
end
