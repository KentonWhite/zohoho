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
  
  it 'should get single name contact Girih' do
    VCR.use_cassette('contact_single', :record => :new_episodes) do
      @contact = @crm.contact "Girih"
    end
    @contact["CONTACTID"].should == "384023000000051007"    
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
  
  it 'should add a note to Johnny Depp' do
    VCR.use_cassette('note', :record => :new_episodes) do
      @note = @crm.post_note "384023000000055001", "Note to self", "Don't do that again" 
    end
    @note.should == "384023000000056001"    
  end
end
