require 'rails_helper'

RSpec.describe 'Tweets', type: :request do
  describe 'GET /tweets' do
    before do
      @tweet1 = Tweet.create!(body: 'First tweet')
      @tweet2 = Tweet.create!(body: 'Second tweet')
      @tweet3 = Tweet.create!(body: 'Third tweet')
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
end
