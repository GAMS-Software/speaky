# frozen_string_literal: true

require "spec_helper"

RSpec.describe Speaky::VectorstoreQdrant do
  it "should be initialized with a configuration" do
    next unless QDRANT_CONFIGURED

    vectorstore = Speaky::VectorstoreQdrant.new({
      url: ENV["QDRANT_URL"],
      api_key: ENV["QDRANT_API_KEY"],
      collection_name: ENV["QDRANT_COLLECTION_NAME"]
    })

    expect(vectorstore.config).to eq({
      url: ENV["QDRANT_URL"],
      api_key: ENV["QDRANT_API_KEY"],
      collection_name: ENV["QDRANT_COLLECTION_NAME"]
    })
  end

  it "should raise an error if the url is not set" do
    next unless QDRANT_CONFIGURED

    expect {
      Speaky::VectorstoreQdrant.new({
        api_key: ENV["QDRANT_API_KEY"],
        collection_name: ENV["QDRANT_COLLECTION_NAME"]
      })
    }.to raise_error(ArgumentError, 'url is required')
  end

  it "should raise an error if the api_key is not set" do
    next unless QDRANT_CONFIGURED

    expect {
      Speaky::VectorstoreQdrant.new({
        url: ENV["QDRANT_URL"],
        collection_name: ENV["QDRANT_COLLECTION_NAME"]
      })
    }.to raise_error(ArgumentError, 'api_key is required')
  end

  it "should raise an error if the collection_name is not set" do
    next unless QDRANT_CONFIGURED

    expect {
      Speaky::VectorstoreQdrant.new({
        url: ENV["QDRANT_URL"],
        api_key: ENV["QDRANT_API_KEY"]
      })
    }.to raise_error(ArgumentError, 'collection_name is required')
  end

  it "should add a vector" do
    next unless QDRANT_CONFIGURED && OPENAI_CONFIGURED

    # HACK: force speaky @llm to be initialized with OpenAI config
    Speaky.instance_variable_set(:@llm, Speaky::LlmOpenai.new({
      access_token: ENV["OPENAI_ACCESS_TOKEN"]
    }))

    vectorstore = Speaky::VectorstoreQdrant.new({
      url: ENV["QDRANT_URL"],
      api_key: ENV["QDRANT_API_KEY"],
      collection_name: ENV["QDRANT_COLLECTION_NAME"]
    })

    result = vectorstore.add("CUSTOM_1", "Hello, world!")
    expect(result).to eq(true)

    # HACK: reset speaky @llm
    Speaky.instance_variable_set(:@llm, nil)
  end

  it "should query vectors" do
    next unless QDRANT_CONFIGURED && OPENAI_CONFIGURED

    # HACK: force speaky @llm to be initialized with OpenAI config
    Speaky.instance_variable_set(:@llm, Speaky::LlmOpenai.new({
      access_token: ENV["OPENAI_ACCESS_TOKEN"]
    }))

    vectorstore = Speaky::VectorstoreQdrant.new({
      url: ENV["QDRANT_URL"],
      api_key: ENV["QDRANT_API_KEY"],
      collection_name: ENV["QDRANT_COLLECTION_NAME"]
    })

    result = vectorstore.query("Hello what?")
    expect(result).to be_an(Array)

    # HACK: reset speaky @llm
    Speaky.instance_variable_set(:@llm, nil)
  end

  it "should remove a vector" do
    next unless QDRANT_CONFIGURED

    vectorstore = Speaky::VectorstoreQdrant.new({
      url: ENV["QDRANT_URL"],
      api_key: ENV["QDRANT_API_KEY"],
      collection_name: ENV["QDRANT_COLLECTION_NAME"]
    })

    result = vectorstore.remove('CUSTOM_1')
    expect(result).to eq(true)
  end

  it "should reset the vectorstore" do
    next unless QDRANT_CONFIGURED

    vectorstore = Speaky::VectorstoreQdrant.new({
      url: ENV["QDRANT_URL"],
      api_key: ENV["QDRANT_API_KEY"],
      collection_name: ENV["QDRANT_COLLECTION_NAME"]
    })

    result = vectorstore.reset
    expect(result).to eq(true)
  end
end
