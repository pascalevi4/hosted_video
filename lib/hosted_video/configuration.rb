module HostedVideo
  class Configuration
    attr_accessor :additional_providers

    def initialize
      @providers = Providers.constants
                            .reject { |const| const == :Base }
                            .map    { |const| Providers.const_get(const) }
                            .select { |const| Class === const }
      @additional_providers = []
    end

    def providers
      @providers + @additional_providers
    end
  end
end
