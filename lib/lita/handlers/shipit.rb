require 'pry'

module Lita
  module Handlers
    class Shipit < Handler

      config :travis_room, default: '#general'

      http.post '/shipit/travis', :travis_webhook

      route /talk_travis/, :talk_travis

      def travis_webhook(request, response)
        raw_json = request.params.fetch('payload')
        travis_hook = Lita::TravisWebhook.new(raw_json)
        handle_travis_build(travis_hook)
      end

      def handle_travis_build(hook)
        if hook.working?
          announce "we did it, twitch!"
        else
          announce "it was a bad build."
        end
      end

      def announce(message)
        msg = "Received announcement: #{message}"
        puts msg
        robot.send_message Source.new(room: '#general'), msg
      end

      Lita.register_handler(self)
    end
  end
end
