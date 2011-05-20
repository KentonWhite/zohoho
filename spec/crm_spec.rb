require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::CRM" do 
  
  before :each do
    @username = 'kentonwhite'
    @password = 'mopa3lwb'
    @apikey = 'L-PvsrDNn9EIW2phA3vzp9YuL5REECogkQaMGWeIdlI$'
    @crm = Zohoho::Crm.new(@username, @password, @apikey) 
    vcr_config 'crm'    
  end 
  
  it 'should get contact Kenton White' do
    VCR.use_cassette('contact', :record => :new_episodes) do
      @contact = @crm.contact "Kenton White"
    end
    @contact["CONTACTID"].should == "384023000000045001"
  end 
  
  it 'should return nil for Johnny Depp' do
    VCR.use_cassette('contact', :record => :new_episodes) do
      @contact = @crm.contact "Johnny Depp"
    end
    @contact.should == nil    
  end
  
  it 'should add Johnny Depp as a new contact' do
    VCR.use_cassette('add_contact', :record => :new_episodes) do
      @contact = @crm.add_contact "Johnny Depp"
    end
    @contact.should == "384023000000055001"        
  end
end
