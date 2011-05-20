require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zohoho::CRM" do 
  
  before :each do
    @username = 'kentonwhite'
    @password = 'mopa3lwb'
    @apikey = 'L-PvsrDNn9EIW2phA3vzp9YuL5REECogkQaMGWeIdlI$'
    @conn = Zohoho::CRM.new(@username, @password, @apikey) 
    vcr_config 'crm'    
  end
end
