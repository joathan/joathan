# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweets::Fetcher, type: :service do
  let!(:company) { Company.create!(name: 'Test Corp') }
  let!(:user) { User.create!(username: 'alice', company: company) }

  before do
    Tweet.create!(body: 'Tweet 1', user: user)
    Tweet.create!(body: 'Tweet 2', user: user)
    Tweet.create!(body: 'Tweet 3', user: user)
  end

  it 'fetches tweets in reverse order by default' do
    tweets = described_class.new(username: nil, cursor: nil, limit: nil).call
    expect(tweets.map(&:body)).to eq(['Tweet 3', 'Tweet 2', 'Tweet 1'])
  end

  it 'limits the number of tweets returned' do
    tweets = described_class.new(username: nil, cursor: nil, limit: 2).call
    expect(tweets.count).to eq(2)
  end

  it 'fetches tweets from a specific user' do
    tweets = described_class.new(username: 'alice', cursor: nil, limit: nil).call
    expect(tweets).to all(have_attributes(user_id: user.id))
  end

  it 'fetches tweets after a cursor' do
    last_tweet = Tweet.order(:id).last
    tweets = described_class.new(username: nil, cursor: last_tweet.id, limit: nil).call

    expect(tweets).to all(satisfy { |t| t.id < last_tweet.id })
    expect(tweets.map(&:body)).to match_array(['Tweet 1', 'Tweet 2'])
  end
end
