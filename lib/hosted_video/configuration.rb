module HostedVideo
  class Configuration
    attr_accessor :additional_providers

    def initialize
      @providers = Providers.constants
                            .reject { |c| c == :Base }
                            .map    { |c| Providers.const_get(c) }
                            .select { |c| Class === c }
      @additional_providers = []
    end

    def providers
      @providers + @additional_providers
    end
  end
end