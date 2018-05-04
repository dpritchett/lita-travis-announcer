require 'spec_helper'
require 'pry'

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
end
