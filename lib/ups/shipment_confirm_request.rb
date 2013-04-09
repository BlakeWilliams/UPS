module UPS
  class ShipmentConfirmRequest

    # Creates a new instance of a ShipmentConfirmRequest
    def initialize
    end

    # Set the shipper information
    # Params:
    # +name+:: Ship from name
    # +address+:: Ship from address
    # +address2+:: (optional) Second address line
    # +city+:: Ship from city
    # +state+:: (optional) Two character state/province code
    # +zip+:: (optional) Ship from Postal Code
    # +country_code+:: (optional) Defaults to 'US'
    def ship_from(*shipping_info)
      @ship_from = shipping_info
    end

    # Set the shipment information
    # Params:
    # +name+:: Ship to name
    # +address+:: Ship to address
    # +address2+:: (optional) Second address line
    # +city+:: Ship to city
    # +state+:: (optional) Two character state/province code
    # +zip+:: (optional) Ship to Postal Code
    # +country_code+:: (optional) Defaults to 'US'
    def ship_to(*shipping_info)
      @ship_to = shipping_info
    end

    # Set the payment information for the ShipmentConfirmRequest to bill the shipper
    # Params:
    # +credit_card+:: {UPS::CreditCard}[rdoc-ref:UPS::CreditCard] The Credit Card provider
    # +card_number+:: The credit cards number
    # +expiration_date+:: The credit cards expiration date in the 'MMYYYY' format
    # +security_code+ (optional):: The 3-4 digit security code for the credit card.
    def bill_shipper(*payment_info)
      @payment_info = payment_info
    end

    # Sets the shipment type for this shipment
    # Params:
    # +type+:: Accepts a {UPS::ShipmentType}[rdoc-ref:UPS::ShipmentType]
    def shipment_type(type)
      @packaging_type = type
    end

    # Sets the shipment type for this shipment
    # Params:
    # +type+:: Accepts a {UPS::PackageType}[rdoc-ref:UPS::PackageType]
    def package_type(type)
      @package_type = type
    end

    # Sends the ShipmentConfirmRequest and returns a response and raises a {UPS::APIError}[rdoc-ref:UPS::APIError]
    # if the ShipmentConfirmRequest hasn't been provided payment info, from shipping info, or to 
    # shipping info.
    def send_request
      raise UPS::APIError, 'You must provide payment info' if !@payment_info
      raise UPS::APIError, 'You must provide from shipment info' if !@ship_from
      raise UPS::APIError, 'You must provide to shipment info' if !@ship_to
      raise UPS::APIError, 'You must provide a packaging type' if !@packaging_type
      raise UPS::APIError, 'You must provide dimensions/measurements' if !@measurements
      # TODO: make request and return new object
    end

    # Sets the dimensions of your package
    # Params:
    # +unit+:: The units that you want to use, accepts the following:
    # A = Barrel, BE = Bundle, BG = Bag, BH = Bunch, BOX = Box, BT = Bolt,
    # BU = Butt, CI = Canister, CM = Centimeter, CON = Container,
    # CR = Crate, CS = Case, CT = Carton, CY = Cylinder, DOZ = Dozen,
    # EA = Each, EN = Envelope, FT = Feet, KG = Kilogram,
    # KGS = Kilograms, LB = Pound, LBS = Pounds, L = Liter,
    # M = Meter, NMB = Number, PA = Packet, PAL = Pallet,
    # PC = Piece, PCS = Pieces, PF = Proof Liters, PKG = Package ,
    # PR = Pair, PRS = Pairs, RL = Roll, SET = Set,
    # SME = Square Meters, SYD = Square Yards, TU = Tube,
    # YD = Yard, OTH = Other.
    # +length+:: Package length
    # +width+:: Package width
    # +height+:: Package height
    def dimensions(*measurements)
      @measurements = measurements
    end

    private

    # Builds the request that we will send to the API
    def build_request(options)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.ShipmentConfirmRequest {
          xml.Request {
            xml.RequestAction 'ShipConfirm'
            xml.RequestOption 'nonvalidate'
          }
        }
        xml.Shipment {
          xml.Shipper {
            xml.Name @ship_from[:name]
            xml.ShipperNumber UPS.shipper_number
            xml.Address {
              xml.AddressLine1 @ship_from[:address]
              xml.AddressLine2 @ship_from[:address2] if @ship_from[:address2]
              xml.City @ship_from[:city]
              xml.StateProvinceCode @ship_from[:state] if @ship_from[:state]
              xml.PostalCode @ship_from[:zip] if @ship_from[:zip]
              xml.CountryCode @ship_from[:country] || 'US'
            }
          }
          xml.ShipTo {
            xml.CompanyName @ship_to[:name]
            xml.Address {
              xml.AddressLine1 @ship_to[:address]
              xml.AddressLine2 @ship_to[:address2] if @ship_to[:address2]
              xml.City @ship_to[:city]
              xml.StateProvinceCode @ship_to[:state] if @ship_to[:state]
              xml.PostalCode @ship_to[:zip] if @ship_to[:zip]
              xml.PostalCode @ship_to[:country] || 'US'
            }
          }
        }
        xml.Service {
          xml.Code @shipment_type
        }
        xml.PaymentInformation {
          xml.Prepaid {
            xml.BillShipper {
              xml.type @payment_info[:credit_card]
              xml.type @payment_info[:card_number]
              xml.type @payment_info[:expiration_date]
              xml.type @payment_info[:security_code] if @payment_info[:security_code]
            }
          }
        }
        xml.Package {
          xml.PackagingType {
            xml.type @package_type
          }
          xml.Dimensions {
            xml.UnitOfMeasurement {
              @measurements[:unit]
            }
            xml.Length @measurements[:length]
            xml.Width @measurements[:width]
            xml.Height @measurements[:height]
          }

          xml.PackageWeight {
            xml.Weight @measurements[:weight]
          }
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
