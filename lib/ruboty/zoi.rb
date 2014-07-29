require "ruboty/zoi/version"
require "open-uri"
require "json"

module Ruboty
  module Handlers
    class Zoi < Base

      ZOI_DATA_URI = "http://zoi.herokuapp.com/js/services.js"

      on(
        /zoi(?:\s+(.*))?/,
        name: 'zoi',
        description: 'gambaru zoi'
      )

      def zoi(message)
        keyword = message.match_data[1]
        if keyword == "list"
          message.reply(fetch_data.map {|z| z["word"] }.uniq.sort.join(", "))
        else
          message.reply(find_zoi_by_keyword(keyword)["image"])
        end
      end

      private
      def find_zoi_by_keyword(keyword)
        data = fetch_data
        if keyword
          entry = data.select { |z| z["word"].include?(keyword) }.sample
        end

        entry || data.sample
      end

      def fetch_data
        zoi_data = open(ZOI_DATA_URI).read
        zoi_data = zoi_data.
          match(/this.items = (.+?);/m)[1].
          gsub(/(word|image|src):/, "'\\1':").
          gsub("'", '"')
        JSON.parse(zoi_data)
      end
    end
  end
end
