require 'spec_helper'
require 'pry'
require 'json'

describe Lita::Handlers::TravisAnnouncer, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }

  def load_fixture(name)
    path = File.join('spec', 'fixtures', "#{name}.json")
    as_text = open(path).readlines.join("\n")

    result = Lita::TravisWebhook.new(as_text)
  end

  describe 'routes' do
    it {
      is_expected.to route_http(:post, '/travis-announcer/travis')
        .to(:travis_webhook)
    }

    #it {
      #is_expected.to(route('Lita play url http://zombo.com')
        #.to(:handle_sonos_play_url))
    #}
  end

  describe 'travis webhooks' do
    it 'should deal with the incoming json payload' do
      result = load_fixture('travis_success')
    end
  end

  describe 'announcing build results' do
    it 'should work idk' do
      subject.announce 'hi there'
    end
  end
end
