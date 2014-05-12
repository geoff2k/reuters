module Reuters
  module Client
    # Retrieves a new Token from the Reuter's API using the
    # credentials that have been passed in to the constructor.
    #
    # @example Retrieving a new token
    #  credentials = { username: "bob", password: "hello", app_id: "1234" }
    #  authentication = Reuters::Client::Token.new credentials
    #  authentication.token #=> "raj2ja89djf98aj3jjoadjowajdoiaj"
    class Token < Base

      # @!attribute [r] token
      #   The token that has been retrieved from the Reuter's API.
      #   @return [String, Nil] the token contents, or nil if not set.

      # @!attribute [r] expires_at
      #   The timestamp at which the associated token will expire.
      #   @return [Integer, Nil] the expiry time of the token, or nil if not set.

      attr_reader :token

      attr_reader :expires_at

      # Initializes a new instance of {Token} and automatically
      # attempts to retieve a new token from the Reuter's API.
      #
      # @param [Hash] creds to be used to authenticate.
      #
      # @option creds [String] :username Username to be used.
      # @option creds [String] :password Password to be used.
      # @option creds [String] :app_id   Application ID to be used.
      #
      # @return [Token] an initialized instance of {Token}
      def initialize(creds = {})
        response = request :n0, "CreateServiceToken_Request_1" do
          soap.header = {
            "adr:To": soap.endpoint,
            "adr:Action": "#{Reuters.namespaces_endpoint}/webservices/rkd/TokenManagement_1/CreateServiceToken_1"
          }

          Reuters::Credentials.details do |user, pass, app|
            soap.body = {
              "n1:ApplicationID": app,
              "n0:Username": user,
              "n0:Password": pass,
            }
          end
        end

        @token = response[:create_service_token_response_1][:token]
        @expires_at = response[:create_service_token_response_1][:expiration]

      end

      def self.wsdl
        "#{Reuters.wsdl_endpoint}/..."
      end

      def self.namespace
        "#{Reuters.namespaces_endpoint}/#{Reuters::Namespaces::Token.management}"
      end

    end
  end
end