require 'ups'
require 'minitest/autorun'
require 'minitest/pride'

API_KEY = '12345'
USERNAME = 'username'
PASSWORD = 'password'
SHIPPER_NUMBER = '12345'

def setup_api
  UPS.api_key = API_KEY
  UPS.username = USERNAME
  UPS.password = PASSWORD
  UPS.shipper_number = SHIPPER_NUMBER
end

def clear_api
  UPS.api_key = nil
  UPS.username = nil
  UPS.password = nil
  UPS.shipper_number = nil
end
