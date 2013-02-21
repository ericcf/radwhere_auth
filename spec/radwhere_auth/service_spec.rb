require 'minitest/spec'
require 'minitest/autorun'
require 'fakeweb'
FakeWeb.allow_net_connect = false

require 'radwhere_auth'

describe RadwhereAuth::Service do

  before do
    @service = RadwhereAuth::Service.new :portal_url => "http://foo.bar"
  end

  describe "sign in request" do

    it "sends the username and password" do
      FakeWeb.register_uri :post,
                           "http://foo.bar/services/auth.asmx/SignIn",
                           :body => "",
                           :status => ["200", "OK"]
      @service.authenticate(:username => "bar", :password => "secret")
      FakeWeb.last_request.body.
        must_equal("username=bar&password=secret&systemID=1&accessCode=1")
    end

    describe "when it is successful" do

      it "returns true" do
        FakeWeb.register_uri :post,
                             "http://foo.bar/services/auth.asmx/SignIn",
                             :body => "",
                             :status => ["200", "OK"]
        @service.authenticate(:username => "bar", :password => "secret").
          must_equal(true)
      end
    end

    describe "when it is unsuccessful" do
      it "returns false" do
        FakeWeb.register_uri :post,
                             "http://foo.bar/services/auth.asmx/SignIn",
                             :body => "Commissure Portal Exception\r\n",
                             :status => ["500", "Internal Server Error"]
        @service.authenticate(:username => "bar", :password => "secret").
          must_equal(false)
      end
    end
  end
end
