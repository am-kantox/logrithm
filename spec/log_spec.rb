require 'spec_helper'

describe Logrithm::Log do
  let!(:text) do
    <<-TEXT
    Rounds a float to the smallest integer greater than or equal to num.
    ceil/2 also accepts a precision to round a floating point value down to an
    arbitrary number of fractional digits (between 0 and 15).
    This function always returns floats. Kernel.trunc/1 may be used instead to truncate the result to an integer afterwards.
    TEXT
  end

  it 'skips empty strings' do
    Logrithm.info ""
  end

  it 'logs properly (one argument)' do
    # expect { Logrithm.fatal(42, "StringInstance", param: :yes) }.to output(/∅/).to_stdout
    Logrithm.info "Hey, I am a string!"
  end

  it 'logs properly (fatal)' do
    # expect { Logrithm.fatal(42, "StringInstance", param: :yes) }.to output(/∅/).to_stdout
    Logrithm.fatal(42, "StringInstance", param: :yes)
  end

  it 'logs properly (error)' do
    # expect { Logrithm.error(42, "StringInstance", param: :yes); sleep 0.5 }.to output(/✘/).to_stdout
    Logrithm.error(42, "StringInstance", param: :yes)
  end

  it 'logs properly (warn)' do
    # expect { Logrithm.warn(42, "StringInstance", param: :yes) }.to output(/G✗/).to_stdout
    Logrithm.warn(42, "StringInstance", param: :yes)
  end

  it 'logs properly (info)' do
    # expect { Logrithm.info(42, "StringInstance", param: :yes) }.to output(/G✔/).to_stdout
    Logrithm.info(42, "StringInstance", param: :yes)
  end

  it 'logs properly (debug)' do
    # expect { Logrithm.debug(42, "StringInstance", param: :yes) }.to output(/G✓/).to_stdout
    Logrithm.debug(42, "StringInstance", param: :yes)
  end
end
