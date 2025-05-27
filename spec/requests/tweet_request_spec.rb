require 'rails_helper'

RSpec.describe 'Tweets', type: :request do
  let!(:company) { Company.create!(name: 'Test Corp') }

  describe 'GET /tweets' do
    let!(:user) { User.create!(username: 'test_user', company: company) }

    before do
      @tweet1 = Tweet.create!(body: 'First tweet', user: user)
      @tweet2 = Tweet.create!(body: 'Second tweet', user: user)
      @tweet3 = Tweet.create!(body: 'Third tweet', user: user)
    end

    it 'returns the most recent tweets by default' do
      get '/tweets'

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['tweets'].map { |t| t['body'] }).to eq(['Third tweet', 'Second tweet', 'First tweet'])
    end

    it 'paginates using cursor' do
      get '/tweets', params: { limit: 2 }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['tweets'].length).to eq(2)
      expect(body['next_cursor']).to eq(@tweet2.id)

      get '/tweets', params: { limit: 2, cursor: body['next_cursor'] }

      body = JSON.parse(response.body)
      expect(body['tweets'].length).to eq(1)
      expect(body['tweets'].first['body']).to eq('First tweet')
    end
  end

  describe 'GET /users/:username/tweets' do
    let!(:user) { User.create!(username: 'alice', company: company) }

    before do
      @tweet1 = Tweet.create!(body: 'user tweet 1', user: user)
      @tweet2 = Tweet.create!(body: 'user tweet 2', user: user)
    end
  
    it 'returns only tweets from the given user' do
      get "/users/#{user.username}/tweets"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      tweets = body['tweets']

      expect(tweets).to all(satisfy { |t| t['user_id'] == user.id })
      expect(tweets.map { |t| t['body'] }).to match_array(['user tweet 1', 'user tweet 2'])
    end
  end
end
