require 'spec_helper'

describe Logrithm::Spitters do
  let!(:exception) { ArgumentError.new("Argument Error Message") }
  let!(:nested_exception) do
    begin
      begin
        fail StandardError, 'Standard Error Message'
      rescue
        raise ArgumentError, 'Argument Error Message'
      end
    rescue => err
      err
    end
  end

  it "prints the exception out" do
    puts Logrithm::Spitters::Exception.new(exception).formatted
  end

  it "prints the nested exception out" do
    puts Logrithm::Spitters::Exception.new(nested_exception).formatted
  end
end
