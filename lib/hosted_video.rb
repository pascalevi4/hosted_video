require "open-uri"
require "json"
require "hosted_video/version"
require "hosted_video/configuration"
require "hosted_video/providers/base"

module HostedVideo
  class InvalidUrlError < StandardError; end

  Dir[File.dirname(__FILE__) + '/hosted_video/providers/*.rb'].each { |file| require file }

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def from_url(url)
      if provider = find_provider(url)
        provider.new(url)
      else
        raise InvalidUrlError
      end
    end

    private
    def find_provider(url)
      configuration.providers.detect { |p| p.can_parse?(url) }
    end
  end
end
