require 'spec_helper'

RSpec.describe FileOrganizer::Tracker::LogTracker do
  let(:tracker) { described_class.new(logger: logger) }
  let(:logger)  { spy }

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

  it do
    msg = "Processing with FileOrganizer::Processor::Dummy " +
      "resulted with error; " +
      "message: 'ErrorKlass: blaa blaa' " +
      "origin: /tmp/source/blabla.tmp " +
      "destination: /tmp/destination/blabla.tmp " +
      "guid: 6888888888888888888888888888888d"
    expect(logger)
      .to have_received(:info)
      .with(msg)
  end
end
