class TweetsController < ApplicationController
  def index
    tweets = Tweets::Fetcher.new(
      username: params[:username],
      cursor: params[:cursor],
      limit: params[:limit]
    ).call

    render json: {
      tweets: tweets.as_json(only: [:id, :body, :user_id, :created_at, :updated_at]),
      next_cursor: tweets.last&.id
    }
  end
end
