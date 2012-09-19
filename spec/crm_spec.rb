require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::CRM" do 
  
  context 'class methods' do
    
    before :each do
      @user = 'user'
      @password = 'password'
      vcr_config 'crm'          
    end
    
    it 'should generate a token for the CRM' do
      token = VCR.use_cassette('generate_token', :record => :new_episodes) do
        Zohoho::Crm.generate_token('user', 'password')
      end
      token.should == 'e0c8f7c27d16587ff6d166419a529b4e' 
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
      @contact.should == "384023000000077001"        
    end
  
    it 'should add a note to Johnny Depp' do
      VCR.use_cassette('note', :record => :new_episodes) do
        @note = @crm.post_note "384023000000055001", "Note to self", "Don't do that again" 
      end
      @note.should == "384023000000078001"    
    end

    it 'should delete a lead' do
      VCR.use_cassette('delete_lead', :record => :new_episodes) do
        @response = @crm.remove_lead 'depp@example.com'
      end
      @response.should == "588305000000567019"
    end

    it "should get a lead's name" do
      VCR.use_cassette('lead_name', :record => :new_episodes) do
        lead = Zohoho::Lead.new.find 'willy@example.com'
        lead['LEADID'].should == "588305000000571003"
      end
    end

  end
  
end
