module HostedVideo
  module Providers
    class Rutube < Base
      def self.can_parse?(url)
        url =~ /rutube\.ru\/video\/(\w{32}|\w{7}).*/
      end

      def preview
        JSON.load(open("http://rutube.ru/api/video/#{vid}/?format=json"))['thumbnail_url']
      end

      private

      def vid_regex
        /(https?:\/\/)?(www\.)?rutube\.ru\/video\/(?<id>\w{32}|\w{7}).*/
      end
    end
  end
end

