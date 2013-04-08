require File.expand_path('../test_helper', __FILE__)

class UPSTest < MiniTest::Unit::TestCase
  def setup
    clear_api
  end

  def test_should_have_valid_access_node
    setup_api

    node = UPS.access_node
    xml = Nokogiri.parse(node)

    # Make sure it's not empty
    refute node.empty?

    # Make sure we have all the right fields
    assert_equal xml.xpath('//AccessLicenseNumber').inner_text, API_KEY
    assert_equal xml.xpath('//userId').inner_text, USERNAME
    assert_equal xml.xpath('//Password').inner_text, PASSWORD
  end

  def test_should_raise_error_without_credentials
    assert_raises UPS::APIError do
      UPS.access_node
    end
  end
end
