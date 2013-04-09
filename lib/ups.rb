require 'ups/credit_card'
require 'ups/error'
require 'ups/package_type'
require 'ups/shipment_confirm_request'
require 'ups/shipment_type'
require 'ups/version'
require 'nokogiri'

module UPS
  @@api_key = nil
  @@username = nil
  @@password = nil
  @@shipper_number = nil
  
  @@base_url = 'https://wwwcie.ups.com/'

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.username=(username)
    @@username = username
  end

  def self.password=(password)
    @@password = password
  end

  def self.shipper_number=(shipper_number)
    @@shipper_number = shipper_number
  end

  private
  def self.access_node
    unless @@api_key && @@username && @@password && @@shipper_number
      raise UPS::APIError, "API Credentials not configured"
    end
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.AccessRequest("xml:lang" => 'en-US') {
        xml.AccessLicenseNumber @@api_key
        xml.userId @@username
        xml.Password @@password
      }
    end
    builder.to_xml
  end
end
