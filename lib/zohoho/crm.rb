module Zohoho 
  require 'httparty'
  require 'json'
  
  class Crm
    include HTTParty
    
    def initialize(username, password, apikey)
      @conn = Zohoho::Connection.new 'CRM', username, password, apikey
    end 
    
  end 
end