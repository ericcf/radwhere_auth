require 'net/http'
require 'uri'
require 'nokogiri'

module RadwhereAuth

  class Service

    def initialize(options)
      @portal_url = options[:portal_url]
      @system_id = options[:system_id] || 1
      @access_code = options[:access_code] || 1
    end

    def authenticate(params)
      sign_in_uri = URI.parse("#{@portal_url}/services/auth.asmx/SignIn")
      res = nil
      timeout_request do
        res = Net::HTTP.post_form(sign_in_uri,
                                  {
                                    'username'   => params[:username],
                                    'password'   => params[:password],
                                    'systemID'   => @system_id,
                                    'accessCode' => @access_code
                                  })
      end
      case res
      when Net::HTTPSuccess
        @cookie = (res.response["set-cookie"] || "").split(":")[0]
        true
      else
        false
      end
    end

    def active_radiologist_accounts
      res = call_service("GetActiveAccounts", "site=&auth=Radiologist")
      return nil unless res
      doc = Nokogiri::HTML(res.body)

      doc.css("idnamepair").map do |p|
        { :id => p.css("id").first.content, :name => p.css("name").first.content }
      end
    end

    def site_physicians
      res = call_service("GetSitePhysicians", "site=&ordering=false")
      return nil unless res
      doc = Nokogiri::HTML(res.body)

      doc.css("idnamepair").map do |p|
        { :id => p.css("id").first.content, :name => p.css("name").first.content }
      end
    end

    def get_account_by_username(username)
      res = call_service("GetAccountByUsername", "username=#{username}")
      return nil unless res
      doc = Nokogiri::HTML(res.body)
      id, name = doc.css("id").first, doc.css("name").first
      return nil unless id && name

      { :id => id.content, :name => name.content }
    end

    private

    def call_service(name, query)
      uri = URI.parse("#{@portal_url}/services/system.asmx/#{name}")
      res = nil
      timeout_request do
        res = Net::HTTP.new(uri.host, uri.port).start do |http|
          http.post(uri.path, query, { "Cookie" => @cookie })
        end
      end

      res
    end

    def timeout_request
      begin
        timeout(20) do
          yield
        end
      rescue Timeout::Error
      end
    end
  end
end
