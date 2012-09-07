require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::Authentication" do 
  
  before :each do
    vcr_config 'authentication'    
  end

  it 'Should retrieve an authorization token' do
    token = VCR.use_cassette('call', :record => :new_episodes) do
      Zohoho::Authentication.generate_token('ZohoCRM/crmapi', 'user', 'password')
    end
    token.should == 'e0c8f7c27d16587ff6d166419a529b4e'
  end
end