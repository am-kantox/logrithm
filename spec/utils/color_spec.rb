require 'spec_helper'

describe Logrithm::Utils::Color do
  let!(:white) { Logrithm::Utils::Color.new }
  let!(:black) { Logrithm::Utils::Color.new '#000000' }
  let!(:yellow) { Logrithm::Utils::Color.new '#FF0' }
  let!(:purple) { Logrithm::Utils::Color.new 255, 0, 255 }
  let!(:aqua) { Logrithm::Utils::Color.new 0, 255, 255, 128 }
  it 'shows up properly' do
    expect { puts yellow.inspect }.to output(/01;38;05;226m” 🗔=“#FFFF00”/).to_stdout
  end
end
