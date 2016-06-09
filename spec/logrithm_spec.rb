require 'spec_helper'

describe Logrithm do
  it 'has a version number' do
    expect(Logrithm::VERSION).not_to be nil
  end

  describe '#log' do
    let!(:re1) { /\AMessage: / }
    let!(:re2) { /\ASelf: .#<.*?., Message:/ }

    it 'just works on first call' do
      expect { TestNS1::TestNS2::Test.new.test_log }.to output(re1).to_stdout
    end
    it 'works with global var set on subsequent calls' do
      expect { TestNS1::TestNS2::Test.new.test_log }.to output(re2).to_stdout
    end
  end
end
