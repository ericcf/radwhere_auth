A simple client for authenticating against a Nuance RadWhere web service.

Example usage:

    service = RadwhereAuth::Service.new :portal_url  => "http://my.portal",
                                        :system_id   => 123,
                                        :access_code => 456
    service.authenticate :username => "bob", :password => "secret"

Run tests:

    rake test
