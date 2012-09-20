module Zohoho 
  require 'httparty'
  require 'json'
  require 'xmlsimple'
  require 'date'
  require 'open-uri'
  
  class Crm
    include HTTParty
    
    def self.generate_token(user, password)
      Zohoho::Authentication.generate_token('ZohoCRM/crmapi', user, password)
    end
    
    def initialize(auth_token)
      @conn = Zohoho::Connection.new 'CRM', auth_token
    end
    
    def contact(name)
      first_name, last_name = parse_name(name)
      contacts = find_contacts_by_last_name(last_name)
      contacts.select! {|c|
        if c['First Name'].nil? then c['First Name'] = '' end
        first_name.match(c['First Name'])
      } 
      contacts.first
    end

    def add_contact(name)
      first_name, last_name = parse_name(name)
      xmlData = parse_data({'First Name' => first_name, 'Last Name' => last_name}, 'Contacts')  
      record = @conn.call('Contacts', 'insertRecords', {:xmlData => xmlData, :newFormat => 1}, :post) 
      record['Id']    
    end

    def post_note(entity_id, note_title, note_content)
      xmlData = parse_data({'entityId' => entity_id, 'Note Title' => note_title, 'Note Content' => note_content}, 'Notes')
      record = @conn.call('Notes', 'insertRecords', {:xmlData => xmlData, :newFormat => 1}, :post) 
      record['Id']
    end

    def sales_order(id)
      @conn.call('SalesOrders', 'getRecordById', :id => id).first
    end

    def sales_orders(last_modified = nil)
      query = last_modified ? { :lastModifiedTime => last_modified.iso8601 } : {}
      @conn.call('SalesOrders', 'getRecords', query)
    end

    def tasks(last_modified = nil)
      query = last_modified ? { :lastModifiedTime => last_modified.iso8601 } : {}
      @conn.call('Tasks', 'getRecords', query)
    end

    def tasks_by_due_date(due_date)
      date_str = due_date ? due_date.strftime('%Y-%m-%d') : ""
      query = "(Due Date|is|#{date_str})"
      @conn.call('Tasks', 'getSearchRecords', :searchCondition => query, :selectColumns => 'All')
    end
    
    def call(*params)
      @conn.call(*params)
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