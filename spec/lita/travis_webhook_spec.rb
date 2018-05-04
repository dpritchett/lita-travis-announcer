require 'spec_helper'

describe Lita::TravisWebhook do
  let(:input_path) { 'travis_success' }
  let(:json_input) { load_fixture input_path }
  subject { Lita::TravisWebhook.new json_input }

  it 'should parse a known good response' do
    result = subject.author_name
    expect(result).to match(/Daniel.+Pritchett/i)
  end

  it 'should acknowledge when the build was successful' do
    expect(subject.working?).to be_truthy
    expect(subject.broken?).to be_falsey
  end

  context 'a failed build' do
    let(:input_path) { 'travis_failure' }

    it 'should acknowledge when the build failed' do
      expect(subject.working?).to be_falsey
      expect(subject.broken?).to be_truthy
    end
  end

  describe ':notification_string' do
    let(:result) { subject.notification_string }

    it 'should include the build status' do
      subject.stub(:description) { 'hi mom' }
      expect(result).to include 'hi mom'
    end

    it 'should include the repo name' do
      expect(result).to include 'ruby-bookbot'
    end

    it 'should include the compare URL for the commit' do
      expect(result).to include 'https://github.com/dpritchett/ruby-bookbot/compare/632250aff63e...7379b6e92f7d'
    end

    context 'a bad build' do
      let(:input_path) { 'travis_failure' }

      it 'should include the compare URL for the commit' do
        expect(result).to include 'https://github.com/dpritchett/ruby-bookbot/commit/64794d01af72'
      end
    end

    context 'malformed input' do
      let(:input_path) { 'travis_malformed' }

      it 'throws an error when parsing' do
        expect { subject.description }.to raise_error JSON::ParserError
      end
    end
  end
end
