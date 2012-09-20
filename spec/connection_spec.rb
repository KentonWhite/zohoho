require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::Connection" do 
  
  before :each do
    @conn = Zohoho::Connection.new('CRM', ENV['TOKEN'])
    vcr_config 'connection'    
  end
  
  it "should make a simple call" do
    VCR.use_cassette('call', :record => :new_episodes) do
      @result = @conn.call('Contacts', 'getRecords')
    end
    @result.size.should == 9
  end
end
