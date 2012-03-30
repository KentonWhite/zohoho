module Zohoho
  
  class Authentication
    
    def self.generate_token(scope, email_id, password)
      uri       = URI('https://accounts.zoho.com/apiauthtoken/nb/create')
      uri.query = URI.encode_www_form(:SCOPE => scope, :EMAIL_ID => email_id, :PASSWORD => password)
      
      response = nil
      
      Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
        request  = Net::HTTP::Get.new uri.request_uri
        response = http.request(request)
      end
      
      result = response.body.match(/RESULT=(.+)/)[1]
      
      if response.code == "200" && result == "TRUE"
        response.body.match(/AUTHTOKEN=(.+)/)[1]
      else
        nil
      end
    end
    
  end
  
end