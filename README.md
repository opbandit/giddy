# Giddy
Giddy is a ruby gem for interacting with the Getty API.

# Installation

```
gem install giddy
```

## Configuration
To set up the authorization configuration, use:

```ruby
Giddy.setup do |config|
  config.system_id = "12345"
  config.system_password = "alongpassword"
  config.username = "user"
  config.password = "password"
end
```

## Usage
Searching:
```ruby
images = Giddy::Image.find(:query => "puppy")
# or, with pagination
images = Giddy::Image.find(:query => "kitty", :start => 21, :limit => 20)
```

Get an images details:
```ruby
image = Giddy::Image(:image_id => "182405488")
puts image
puts image.artist
```

Download request:
```ruby
puts image.download_largest
```
