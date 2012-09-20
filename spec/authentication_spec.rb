require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::Authentication" do 
  
  before :each do
    vcr_config 'authentication'    
  end

  it 'Should retrieve an authorization token' do
    token = VCR.use_cassette('call', :record => :new_episodes) do
      Zohoho::Authentication.generate_token('ZohoCRM/crmapi', 'user', 'password')
    end
    token.should == 'af86cc982883822471f67de3f71956e6'
  end
end