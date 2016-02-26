require 'spec_helper'
require 'aws-sdk'
RSpec.describe FileOrganizer::Processor::S3Backup do
  include FileOrganizer::AppTest::ProcessorHelper #trigger

  let(:type)        { 'archive' }
  let(:bucket_name) { 'my-bucket' }
  let(:guid)        { '6eaec6511eec985c9614d97d2d03252d' }
  let(:source_path) { AppTest.test_root_path.join(guid, %q{wierd#'ame.xyz.txt}) }
  let(:processor)   { described_class.new(bucket: bucket_name) }

  before do
    Aws.config[:stub_responses] = true
  end

  it 'should upload the file to s3' do
    bucket_resource = instance_double(Aws::S3::Bucket)
    s3_object_resource = instance_double(Aws::S3::Object)

    expect(Aws::S3::Bucket)
      .to receive(:new)
      .with(bucket_name)
      .and_return(bucket_resource)

    expect(bucket_resource)
      .to receive(:object)
      .with('archive/6eaec6511eec985c9614d97d2d03252d/wierdame.xyz.txt')
      .and_return(s3_object_resource)

    expect(s3_object_resource)
      .to receive(:exists?)
      .and_return(false)

    expect(s3_object_resource)
      .to receive(:upload_file)
      .with(source_path.to_s)

    trigger
  end


  describe 'real connection smoke test upload', real_http: true do

    let(:secrets)     { YAML.load_file(FileOrganizer.config.project_root.join('secrets.yml')) }
    let(:id)          { secrets.fetch('aws').fetch('access_key_id') }
    let(:key)         { secrets.fetch('aws').fetch('secret_access_key') }
    let(:region)      { secrets.fetch('aws').fetch('region') }
    let(:bucket_name) { secrets.fetch('aws').fetch('bucket') }

    before do
      Aws.config.update({
        region: region,
        credentials: Aws::Credentials.new(id, key),
        stub_responses: false
      })

    end

    it do
      trigger
    end
  end
end
