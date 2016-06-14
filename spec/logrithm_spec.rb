require 'spec_helper'

describe Logrithm do
  it 'has a version number' do
    expect(Logrithm::VERSION).not_to be nil
  end

  describe '#log' do
    let!(:re1) { /Hey, dude/ }
    let!(:re2) { /Self: / }

    it 'just works on first call' do
      TestNS1::TestNS2::Test.new.test_log
      # expect { TestNS1::TestNS2::Test.new.test_log }.to output(re1).to_stdout
    end
    it 'works with global var set on subsequent calls' do
      TestNS1::TestNS2::Test.new.test_log
      # expect { TestNS1::TestNS2::Test.new.test_log }.to output(re2).to_stdout
    end
  end
end
