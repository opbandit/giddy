# Giddy
Giddy is a ruby gem for interacting with the Getty API.

# Installation

```
gem install giddy
```

## Configuration
To set up the authorization configuration for the system (different than your per-user credentials), use:

```ruby
Giddy.setup do |config|
  config.system_id = "12345"
  config.system_password = "alongpassword"
end
```

## Usage
First, create a client object with a username and password
```ruby
client = Giddy::Client.new("ausername", "apassword")
```

Searching:
```ruby
images = client.search(:query => "puppy")

# or, with pagination
images = client.search(:query => "kitty", :start => 21, :limit => 20)

# or, by image id (returns only one):
image = client.search(:image_id => "110740425")
```

Get an images details:
```ruby
image = client.search(:image_id => "110740425")
puts image
puts image.artist
```

Download request:
```ruby
puts image.download_largest
```

To get the available sizes, and then the URL of the download for the smallest:
```ruby
image = client.search(:image_id => "136094606")
# image.sizes is ordered by file size, smallest to largest
smallest = image.sizes.first
puts image.download(smallest).url_attachment
```

It's also possible to cache session information so that you don't have to reauthenticate on each client creation.  For instance:
```ruby
client = Giddy::Client.new("username", "password")
# next line happens automatically if a session doesn't exist or if a session goes stale
# let's force it, just to get some tokens
client.create_session

# these can be stored somewhere (memcache, etc)
token = client.token
secure_token = client.secure_token

# create a new client with old tokens so a new session doesn't have to be initialized
# if the tokens have gone stale, a new session will be created
otherclient = Giddy::Client.new("username", "password", token, secure_token)
puts otherclient.search(:image_id => "110740425")
```