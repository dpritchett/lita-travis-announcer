require 'spec_helper'
require 'pry'
require 'json'

describe Lita::Handlers::TravisAnnouncer, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }

  describe 'http routes' do
    it {
      is_expected.to route_http(:post, '/travis-announcer/travis')
        .to(:parse_travis_webhook)
    }
  end

  context 'dummy post request' do
    let(:request) { double 'post request' }
    let(:response) { double 'post response' }
    let(:payload) { load_fixture 'travis_success' }

    before do
      request.stub_chain(:params, :fetch) { payload }
      response.stub :write
    end

    it 'replies to the POSTer with the parsed notification text' do
      expect(response).to receive(:write).with(/ruby-bookbot/)
      subject.parse_travis_webhook(request, response)
    end

    it 'calls :handle_travis_build' do
      expect(subject).to receive(:handle_travis_build)
      subject.parse_travis_webhook(request, response)
    end

    it 'lets shares the build info in chat' do
      expect(subject).to receive(:announce)
        .with(/ruby-bookbot.+some Travis magic/i)
      subject.parse_travis_webhook(request, response)
    end

    context 'the dummy post is a failed build' do
      let(:payload) { load_fixture 'travis_failure' }

      it 'lets folks know about the failure in chat before pasting the link' do
        expect(subject).to receive(:announce).exactly(2).times
        subject.parse_travis_webhook(request, response)
      end
    end
  end
end
