module Zohoho
  require 'httparty'
  require 'json'
  require 'xmlsimple'
  require 'date'
  require 'open-uri'
  
  class Lead
    include HTTParty

    def initialize
      @conn = Zohoho::Connection.new 'CRM', ENV['TOKEN']
    end

    def find(email)
      leads = @conn.call('Leads', 'getSearchRecords', :searchCondition => "(Email|=|#{email})", :selectColumns => 'All')
      return leads.first if leads.count > 0
      nil
    end

  end
end