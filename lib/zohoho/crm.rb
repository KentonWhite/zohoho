module Zohoho 
  require 'httparty'
  require 'json'
  require 'xmlsimple'
  
  class Crm
    include HTTParty
    
    def initialize(username, password, apikey)
      @conn = Zohoho::Connection.new 'CRM', username, password, apikey
    end
    
    def contact(name)
      first_name, last_name = parse_name(name)
      contacts = find_contacts_by_last_name(last_name)
      contacts.select! {|c| first_name.match(c['First Name'])} 
      contacts.first
    end 

    def add_contact(name)
      first_name, last_name = parse_name(name)
      xmlData = parse_data({'First Name' => first_name, 'Last Name' => last_name}, 'Contacts')
     record = @conn.call('Contacts', 'insertRecords', {:xmlData => xmlData, :newFormat => 1}, :post)
     record['Id']    
    end
    
    private 
    
    def parse_name(name)
      match_data = name.match(/\s(\S*)$/)
      match_data.nil? ? last_name = name : last_name = match_data[1]

      match_data = name.match(/^(.*)\s/)
      match_data.nil? ? first_name = '' : first_name = match_data[1]

      return first_name, last_name
    end 

    def parse_data(data, entry)
      fl = data.map {|e| Hash['val', e[0], 'content', e[1]]}
      row = Hash['no', '1', 'FL', fl]
      data = Hash['row', row]
      XmlSimple.xml_out(data, :RootName => entry)    
    end

    def find_contacts_by_last_name(last_name)
      search_condition = "(Contact Name|ends with|#{last_name})"
  @conn.call('Contacts', 'getSearchRecords', :searchCondition => search_condition, :selectColumns => 'All')
    end
    
  end 
end