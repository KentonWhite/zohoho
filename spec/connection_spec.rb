require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::Connection" do 
  
  before :each do
    @username = 'kentonwhite'
    @password = 'mopa3lwb'
    @apikey = 'L-PvsrDNn9EIW2phA3vzp9YuL5REECogkQaMGWeIdlI$'
    @conn = Zohoho::Connection.new('CRM', @username, @password, @apikey) 
    vcr_config 'connection'    
  end

  it "should create the proper ticket url" do
    ticket_url = "https://accounts.zoho.com/login"
    @conn.ticket_url.should == ticket_url
  end
  
  it "should get a new ticket" do
    VCR.use_cassette('ticket', :record => :new_episodes) do
      @ticket = @conn.ticket
    end
    @ticket.should == '69617ea2200f689765ac4e1b44233128'
  end 
  
  it "should make a simple call" do
    VCR.use_cassette('call', :record => :new_episodes) do
      @result = @conn.call('Contacts', 'getRecords')
    end
    @result.size.should == 9
  end
end
