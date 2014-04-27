hosted_video
============

Ruby gem for parsing urls to determine video hostings and get video details.

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
