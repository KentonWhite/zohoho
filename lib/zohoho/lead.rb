module Zohoho
  require 'httparty'
  require 'json'
  require 'xmlsimple'
  require 'date'
  require 'open-uri'

  
  class Lead
    include HTTParty
    attr_accessor :id, :owner_id, :owner_name, :first_name, :last_name, :email, :source

    def initialize(email = nil, info = {})
      @conn = Zohoho::Connection.new 'CRM', ENV['TOKEN']
      if email
        info['Company'] = " " unless info['Company']
        info['Last Name'] = " " unless info['Last Name']
        info.merge!({'Email' => email})
        xmlData = parse_data(info, 'Leads')
        record = @conn.call('Leads', 'insertRecords', {:xmlData => xmlData, :newFormat => 1}, :post)
        return nil if record.empty?
        parse_record(record)
      end
    end

    def find(email)
      @conn ||= Zohoho::Connection.new 'CRM', ENV['TOKEN']
      leads = @conn.call('Leads', 'getSearchRecords', :searchCondition => "(Email|=|#{email})", :selectColumns => 'All')
      return nil if leads.count == 0
      parse_record(leads.first)
      return self
    end

    def delete
      return false if !email
      xmlData = parse_data({'id' => id}, 'Leads')
      result = @conn.call('Leads', "deleteRecords?id=#{id}", {:xmlData => xmlData, :newFormat => 1}, :post)
      result.include?("#{id},Record(s) deleted successfully")
    end

    def save

    end

    private

    def parse_record(record)
      @id = record['LEADID'] || record['Id']
      @owner_id = record['SMOWNERID']
      @owner_name = record['Lead Owner']
      @first_name = record['First Name']
      @last_name = record['Last Name']
      @source = record['Lead Source']
      @email = record['Email']
    end

    def parse_data(data, entry)
      #@TODO DRY
      fl = data.map {|e| Hash['val', e[0], 'content', e[1]]}
      row = Hash['no', '1', 'FL', fl]
      data = Hash['row', row]
      XmlSimple.xml_out(data, :RootName => entry)
    end
  end
end