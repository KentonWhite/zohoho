require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::Connection" do 
  
  before :each do
    @username = 'kentonwhite'
    @password = 'mopa3lwb'
    @conn = Zohoho::Connection.new(@username, @password) 
    vcr_config 'crm'    
  end
  it "should create the proper ticket url" do
    ticket_url = "https://accounts.zoho.com/login?servicename=ZohoCRM&FROM_AGENT=true&LOGIN_ID=#{@username}&PASSWORD=#{@password}"
    @conn.ticket_url('CRM').should == ticket_url
  end
  
  it "should get a new ticket" do
    VCR.use_cassette('ticket', :record => :new_episodes) do
      @ticket = @conn.ticket('CRM')
    end
    @ticket.should == 'c1eea66055af5d42b8b1ab0d1171c9c4'
  end
end
