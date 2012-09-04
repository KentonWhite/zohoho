require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::Connection" do 
  
  before :each do
    @authtoken = 'b0d8b1e2dbe42ef9d60f463fc94557ff'
    @conn = Zohoho::Connection.new('CRM', @authtoken) 
    vcr_config 'connection'    
  end
  
  it "should make a simple call" do
    VCR.use_cassette('call', :record => :new_episodes) do
      @result = @conn.call('Contacts', 'getRecords')
    end
    @result.size.should == 9
  end
end
