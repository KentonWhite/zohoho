module Zohoho 
  require 'httparty' 
  
  class Connection
    include HTTParty
    
    def initialize(username, password)
      @username, @password = username, password
    end 
    
    def ticket_url(service_name)
      "https://accounts.zoho.com/login?servicename=Zoho#{service_name}&FROM_AGENT=true&LOGIN_ID=#{@username}&PASSWORD=#{@password}"
    end 
    
    def ticket(service_name)
      url = ticket_url(service_name) 
      ticket_info = self.class.post(url).parsed_response 
      ticket_info.match(/\sTICKET=(.*)\s/)[1]
    end
    
  end 
end