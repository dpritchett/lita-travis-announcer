require 'pry'

module Lita
  module Handlers
    class TravisAnnouncer < Handler

      config :travis_room, default: 'shell'

      http.post '/travis-announcer/travis', :parse_travis_webhook

      def parse_travis_webhook(request, response)
        raw_json = request.params.fetch('payload')
        travis_hook = Lita::TravisWebhook.from_string(raw_json)
        response.write handle_travis_build(travis_hook)
      end

      def handle_travis_build(hook)
        announce '*Broken build!*' if hook.broken?
        announce hook.notification_string
        hook.notification_string
      end

      def announce(message)
        Lita.logger.debug "Received announcement: #{message}"
        robot.send_message Source.new(room: '#general'), message
      end

      Lita.register_handler(self)
    end
  end
end
