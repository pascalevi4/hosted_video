hosted_video
============
[![Gem Version](https://badge.fury.io/rb/hosted_video.svg)](http://badge.fury.io/rb/hosted_video)
[![Code Climate](https://codeclimate.com/github/pascalevi4/hosted_video/badges/gpa.svg)](https://codeclimate.com/github/pascalevi4/hosted_video)
[![Build Status](https://travis-ci.org/pascalevi4/hosted_video.svg?branch=master)](https://travis-ci.org/pascalevi4/hosted_video)

Ruby gem for parsing urls to determine video hostings and get video details. Youtube, Rutube and Vimeo services are supported.

## Installation

Add this line to your application's Gemfile:

    gem 'hosted_video'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hosted_video

## Usage

```ruby
video = HostedVideo.from_url('http://www.youtube.com/watch?v=TBKN7_vx2xo')
video.vid         # => "TBKN7_vx2xo"
video.preview     # => "http://img.youtube.com/vi/TBKN7_vx2xo/hqdefault.jpg"
video.iframe_code # => "<iframe width='420' height='315' frameborder='0' src='http://www.youtube.com/embed/TBKN7_vx2xo?wmode=transparent'></iframe>"
```

You can create your own video service providers by inheriting from HostedVideo::Providers::Base and implementing parsing functions:
```ruby
class MyProvider < HostedVideo::Providers::Base
  # logic to determine your service
  def self.can_parse?(url)
    url =~ /myprovider\.com\/\d{3}.*/
  end

  # how to get preview image
  def preview
    "http://myprovider.ru/api/video/#{vid}/?preview=true")
  end

  def url_for_iframe
    "http://rutube.ru/video/embed/#{vid}"
  end

  private
  # regular expression for getting video id from link
  def vid_regex
    /(https?:\/\/)?(www\.)?rutube\.ru\/video\/(?<id>\w{32}|\w{7}).*/
  end
end

HostedVideo.configure do |c|
  c.additional_providers += [MyProvider]
end
```
Please send me pull-requests with your providers or write an issue with pasted code.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
