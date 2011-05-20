require 'rubygems'  
require 'rspec'
require 'fakeweb' 
require 'vcr'
require 'mocha'


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'zohoho'

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  # config.mock_with :rspec

end                                    

def vcr_config(dir_name)
  VCR.config do |c|
    c.cassette_library_dir = "spec/fixtures/vcr_cassettes/#{dir_name}"
    c.stub_with :fakeweb # or :webmock
    c.default_cassette_options = {:record => :none}
  end 
end

