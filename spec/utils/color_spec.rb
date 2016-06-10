require 'spec_helper'

describe Logrithm::Utils::Color do
  let!(:white) { Logrithm::Utils::Color.new }
  let!(:black) { Logrithm::Utils::Color.new '#000000' }
  let!(:yellow) { Logrithm::Utils::Color.new '#FF0' }
  let!(:purple) { Logrithm::Utils::Color.new 255, 0, 255 }
  let!(:aqua) { Logrithm::Utils::Color.new 0, 255, 255, 128 }

  let!(:text) do
    <<-TEXT
    Rounds a float to the smallest integer greater than or equal to num.
    ceil/2 also accepts a precision to round a floating point value down to an
    arbitrary number of fractional digits (between 0 and 15).
    This function always returns floats. Kernel.trunc/1 may be used instead to truncate the result to an integer afterwards.
    TEXT
  end

  it 'shows up properly' do
    expect { puts yellow.inspect }.to output(/01;38;05;226m” 🗔=“#FFFF00”/).to_stdout
  end

  it 'draws line of the width of terminal' do
    puts Logrithm::Utils::Output.line color: Logrithm::Utils::Color::BLUE
  end

  it 'draws rectangle' do
    puts Logrithm::Utils::Output.rectangle(
      text,
      width: 80,
      color: Logrithm::Utils::Color.preset(:warning),
      frame_color: Logrithm::Utils::Color::RED
    )
  end
end
