require 'spec_helper'

RSpec.describe FileOrganizer::Processor::HelperObject::UniqueName do
  let(:existence_determiner) { ->(filename){} }
  let(:helper) { described_class.new(existence_determiner: existence_determiner) }
  let(:name) { ' bla bla @#$#!450 e0 .-ub.txt ' }

  describe '#sanitize' do
    subject { helper.sanitize(name) }

    context 'given the name was not taken' do

      it 'should just sanitize name' do
        expect(subject).to eq 'blabla450e0.-ub.txt'
      end
    end

    context 'given the name was taken' do
      let(:existence_determiner) do
        ->(filename) {
          filename.==('blabla450e0.-ub.txt') \
            || filename.==('blabla450e0.-ub-1.txt')
        }
      end

      it 'should sanitize name and generate sufix' do
        expect(subject).to eq 'blabla450e0.-ub-2.txt'
      end
    end
  end
end
