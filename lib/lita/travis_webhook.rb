require 'json'
require 'pry'
require 'ostruct'

module Lita
  class TravisWebhook < OpenStruct
    def initialize(parsed_json)
      @parsed_json = parsed_json
      @ostruct = super
    end

    attr_reader :parsed_json, :ostruct

    def description
      status_message
    end

    def repo_name
      repository.fetch 'name'
    end

    def notification_string
      "*#{description}* [#{repo_name}] >> #{message} >> (#{compare_url})"
    end

    def working?
      %w[Pending Passed Fixed].include? status_message
    end

    def broken?
      !working?
    end

    def keys
      parsed_json.keys
    end
  end
end
