module HostedVideo
  module Providers
    class RutubeByIframe < Rutube
      def self.can_parse?(url)
        url =~ /rutube\.ru\/video\/embed\/(\w{32}|\w{7}).*/
      end

      private

      def vid_regex
        /rutube\.ru\/video\/embed\/(?<id>\w{32}|\w{7}).*/
      end
    end
  end
end

