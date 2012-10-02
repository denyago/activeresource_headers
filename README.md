# Activeresource Headers

Add ability to send custom headers on each http request by an ActiveResource model.

There are two ways of setting headers.
  * class method ```custom_headers do ... end``` in a model, that is an ActiveResource::Base kind
  * chainable method ```with_headers```, that can be putten between model class and ```find``` method

## Examples

```ruby

  class Person < ActiveResource::Base
    include ActiveresourceHeaders::CustomHeaders

    self.site = 'http://example.com'

    custom_headers do
      {"My-Time" => Time.now.to_s}
    end
  end

  Person.find(:all) #=> will add header "My-Time: 2012-10-02 18:56:18 +0300"

  Person.with_headers("My-Time" => "to drink!", "Age" => "25+").find(:all)
    #=> will add headers "My-Time: to drink!" and "Age: 25+"
```


## Installation

Add this line to your application's Gemfile:

    gem 'activeresource_headers'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activeresource_headers

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
