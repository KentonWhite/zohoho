module Zohoho 
  require 'httparty'
  require 'json'
  
  class Connection
    include HTTParty

    attr_reader :auth_token
    
    def initialize(service_name, auth_token)
      @service_name, @auth_token = service_name, auth_token
    end 
    
    def zoho_uri
      zoho_uri = "https://#{@service_name.downcase}.zoho.com/#{@service_name.downcase}/private/json"
    end
    
    def call(entry, api_method, query = {}, http_method = :get)
      query.merge!({ :authtoken => self.auth_token, :scope => "#{@service_name.downcase}api" })

      url = [zoho_uri, entry, api_method].join('/')
      
      case http_method
      when :get
        raw = JSON.parse(self.class.get(url, :query => query))
        parse_raw_get(raw, entry)
      when :post
        raw = JSON.parse(self.class.post(url, :body => query))
        parse_raw_post(raw)
      else
        raise "#{http_method} is not a recognized http method"
      end
    end 
    
    private
    
    def parse_raw_get(raw, entry)
      return [] if raw['response']['result'].nil?
      rows = raw['response']['result'][entry]['row'] 
      rows = [rows] unless rows.class == Array
      rows.map {|i|
        raw_to_hash i['FL']
      }
    end
    
    def parse_raw_post(raw)
      return [] if raw['response']['result'].nil?
      record = raw['response']['result']['recorddetail'] 
      if record
        raw_to_hash record['FL']
      else
        raw['response']['result']['message']
      end
    end
    

    def raw_to_hash(raw)
      raw.map! {|r| [r['val'], r['content']]}
      Hash[raw]
    end
    
  end 
end