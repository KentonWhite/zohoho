require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::CRM" do 
      
  before :each do
    vcr_config 'lead'    
    @lead = Zohoho::Lead.new
  end 

  it 'should delete a lead' do
    VCR.use_cassette('remove', :record => :new_episodes) do
      @lead.find('willy@example.com')
      @lead.delete.should be_true
    end
  end

  it 'should return false deleting a nonexistent lead' do
    VCR.use_cassette('remove_false', :record => :new_episodes) do
      @lead.find('lilly@example.com')
      @lead.delete.should be_false
    end
  end

  it "should get a lead" do
    VCR.use_cassette('get', :record => :new_episodes) do
      @lead.find 'willy@example.com'
      @lead.id.should == "588305000000571003"
      @lead.owner_id.should == "588305000000453003"
      @lead.first_name.should == "Willy"
      @lead.last_name.should == "Watcher"
      @lead.source.should == "app"
    end
  end

  it "should return nil if lead doesn't exist" do
    VCR.use_cassette('get', :record => :new_episodes) do
      @lead.find('lilly@example.com').should be_nil
    end
  end

  it "should add a lead" do
    VCR.use_cassette('add', :record => :new_episodes) do
      lead = Zohoho::Lead.new 'billy@example.com'
      lead.id.should == "588305000000570015"
    end
  end
  
end
