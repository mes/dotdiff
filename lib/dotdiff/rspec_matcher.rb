require 'rspec/expectations'

RSpec::Matchers.define :match_image do |filename, opts = {}|
  match do |page|
    result, @message = outcome(Hash(opts).merge!(file_name: filename, driver: page))
    result == true
  end


  failure_message do |actual|
    "expected to match image but failed with: #{@message}"
  end
end
