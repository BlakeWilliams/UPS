module UPS
  class ShipmentConfirmRequest
    def self.request(*options)
      self.build_request(*options)
    end

    private
    def self.build_request(options)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.ShipmentConfirmRequest {
          xml.Request {
            xml.RequestAction 'ShipConfirm'
            xml.RequestAction 'nonvalidate'
          }
        }
        xml.Shipment {
          xml.Shipper {
            xml.AddressLine1 options[:shipper][:address]
            xml.City options[:shipper][:city]
            xml.StateProvinceCode options[:shipper][:state]
            xml.CountryCode options[:shipper][:country] || 'US'
            xml.PostalCode options[:shipper][:postal_code]
          }
        }
        xml.ShipTo {
          xml.CompanyName options[:ship_to][:name]
          xml.Address {
            xml.AddressLine1 options[:ship_to][:address]
            xml.City options[:ship_to][:city]
            xml.StateProvinceCode options[:ship_to][:state]
            xml.CountryCode options[:ship_to][:country] || 'US'
            xml.PostalCode options[:ship_to][:postal_code]
          }
        }
        xml.Service {
          xml.Code options[:shipping_method][:code]
          xml.Description options[:shipping_method][:description]
        }
        xml.PaymentInformation {
          #todo
        }
        xml.Package {
          xml.PackagingType {
            #todo
          }
        }
        xml.Dimensions {
          # todo
        }

        xml.LabelSpecification {
          xml.LabelPrintMethod "GIF"
          xml.HTTPUserAgent "Mozilla/4.5"
          xml.LabelImageFormat {
            xml.code "GIF"
          }
        }
      end
    end

  end
end
