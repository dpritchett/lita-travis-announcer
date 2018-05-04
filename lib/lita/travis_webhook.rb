require 'json'
require 'pry'
require 'ostruct'

module Lita
  class TravisWebhook
    def initialize(plaintext)
      @raw_json = plaintext
      @parsed = JSON.load plaintext
      @ostruct = OpenStruct.new parsed
    end

    attr_reader :raw_json, :parsed, :ostruct

    def description
      status_message
    end

    def working?
      %w[Pending Passed Fixed].include? status_message
    end

    def broken?
      !working?
    end

    def keys
      parsed.keys
    end

    def method_missing(m, *args, &block)
      if ostruct.respond_to? m
        ostruct.send m, *args, &block
      else
        super
      end
    end

    def respond_to_missing?(*_args)
      true
    end
  end
end
