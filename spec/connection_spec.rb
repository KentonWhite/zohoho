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
    ticket_url = "https://accounts.zoho.com/login?servicename=ZohoCRM&FROM_AGENT=true&LOGIN_ID=#{@username}&PASSWORD=#{@password}"
    @conn.ticket_url.should == ticket_url
  end
  
  it "should get a new ticket" do
    VCR.use_cassette('ticket', :record => :new_episodes) do
      @ticket = @conn.ticket
    end
    @ticket.should == 'c1eea66055af5d42b8b1ab0d1171c9c4'
  end 
  
  it "should make a simple call" do
    VCR.use_cassette('call', :record => :new_episodes) do
      @result = @conn.call('Contacts', 'getRecords')
    end
    @result.size.should == 5
  end
end
