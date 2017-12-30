# coding: utf-8
# © 2016-2017 Resurface Labs LLC

require 'resurfaceio/all'
require_relative 'helper'

describe HttpLogger do

  it 'creates instance' do
    logger = HttpLogger.new
    expect(logger.nil?).to be false
    expect(logger.agent).to eql(HttpLogger::AGENT)
    expect(logger.enableable?).to be false
    expect(logger.enabled?).to be false
  end

  it 'creates multiple instances' do
    url1 = 'http://resurface.io'
    url2 = 'http://whatever.com'
    logger1 = HttpLogger.new(url1)
    logger2 = HttpLogger.new(url: url2)
    logger3 = HttpLogger.new(url: DEMO_URL)

    expect(logger1.agent).to eql(HttpLogger::AGENT)
    expect(logger1.enableable?).to be true
    expect(logger1.enabled?).to be true
    expect(logger1.url).to eql(url1)
    expect(logger2.agent).to eql(HttpLogger::AGENT)
    expect(logger2.enableable?).to be true
    expect(logger2.enabled?).to be true
    expect(logger2.url).to eql(url2)
    expect(logger3.agent).to eql(HttpLogger::AGENT)
    expect(logger3.enableable?).to be true
    expect(logger3.enabled?).to be true
    expect(logger3.url).to eql(DEMO_URL)

    UsageLoggers.disable
    expect(UsageLoggers.enabled?).to be false
    expect(logger1.enabled?).to be false
    expect(logger2.enabled?).to be false
    expect(logger3.enabled?).to be false
    UsageLoggers.enable
    expect(UsageLoggers.enabled?).to be true
    expect(logger1.enabled?).to be true
    expect(logger2.enabled?).to be true
    expect(logger3.enabled?).to be true
  end

  it 'detects string content types' do
    expect(HttpLogger::string_content_type?(nil)).to be false
    expect(HttpLogger::string_content_type?('')).to be false
    expect(HttpLogger::string_content_type?(' ')).to be false
    expect(HttpLogger::string_content_type?('/')).to be false
    expect(HttpLogger::string_content_type?('application/')).to be false
    expect(HttpLogger::string_content_type?('json')).to be false
    expect(HttpLogger::string_content_type?('html')).to be false
    expect(HttpLogger::string_content_type?('xml')).to be false

    expect(HttpLogger::string_content_type?('application/json')).to be true
    expect(HttpLogger::string_content_type?('application/soap')).to be true
    expect(HttpLogger::string_content_type?('application/xml')).to be true
    expect(HttpLogger::string_content_type?('application/x-www-form-urlencoded')).to be true
    expect(HttpLogger::string_content_type?('text/html')).to be true
    expect(HttpLogger::string_content_type?('text/html; charset=utf-8')).to be true
    expect(HttpLogger::string_content_type?('text/plain')).to be true
    expect(HttpLogger::string_content_type?('text/plain123')).to be true
    expect(HttpLogger::string_content_type?('text/xml')).to be true
    expect(HttpLogger::string_content_type?('Text/XML')).to be true
  end

  it 'has valid agent' do
    agent = HttpLogger::AGENT
    expect(agent).not_to be nil
    expect(agent).to be_kind_of String
    expect(agent.length).to be > 0
    expect(agent.end_with?('.rb')).to be true
    expect(agent.include?('\\')).to be false
    expect(agent.include?('\"')).to be false
    expect(agent.include?('\'')).to be false
    expect(HttpLogger.new.agent).to eql(agent)
  end

  it 'skips logging when disabled' do
    MOCK_URLS_DENIED.each do |url|
      logger = HttpLogger.new(url: url).disable
      expect(logger.enableable?).to be true
      expect(logger.enabled?).to be false
      expect(logger.log(nil, nil, nil, nil)).to be true # would fail if enabled
    end
  end

end
