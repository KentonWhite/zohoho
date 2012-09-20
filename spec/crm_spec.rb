require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::CRM" do 
  
  context 'class methods' do
    
    before :each do
      vcr_config 'crm'          
    end
    
    it 'should generate a token for the CRM' do
      token = VCR.use_cassette('generate_token', :record => :new_episodes) do
        Zohoho::Crm.generate_token(ENV['USERNAME'], ENV['PASSWORD'])
      end
      token.should == 'af86cc982883822471f67de3f71956e6'
    end
  end
  
  context 'instance methods' do
    
    before :each do
      vcr_config 'crm'    
      @crm = Zohoho::Crm.new(ENV['TOKEN'])
    end 
  
    it 'should get contact Kenton White' do
      VCR.use_cassette('contact', :record => :new_episodes) do
        @contact = @crm.contact "Kenton White"
      end
      @contact["CONTACTID"].should == "588305000000567027"
    end 
  
    it 'should get single name contact White' do
      VCR.use_cassette('contact_single', :record => :new_episodes) do
        @contact = @crm.contact "White"
      end
      @contact["CONTACTID"].should == "588305000000567027"
    end
    
    it 'should add Johnny Depp as a new contact' do
      VCR.use_cassette('add_contact', :record => :new_episodes) do
        @contact = @crm.add_contact "Johnny Depp"
      end
      @contact.should == "588305000000570009"
    end
  
    it 'should add a note to Johnny Depp' do
      VCR.use_cassette('note', :record => :new_episodes) do
        @note = @crm.post_note "384023000000055001", "Note to self", "Don't do that again" 
      end
      @note.should == "384023000000078001"    
    end
  end
end