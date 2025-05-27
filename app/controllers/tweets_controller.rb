class TweetsController < ApplicationController
  def index
    per_page = (params[:limit] || 10).to_i
    cursor = params[:cursor].to_i if params[:cursor].present?

    tweets = Tweet.order(id: :desc)
    tweets = tweets.by_user_username(params[:username])
    tweets = tweets.where("id < ?", cursor) if cursor.present?
    paginated_tweets = tweets.limit(per_page)
    next_cursor = paginated_tweets.last&.id

    render json: {
      tweets: paginated_tweets.as_json(only: [:id, :body, :user_id, :created_at, :updated_at]),
      next_cursor: next_cursor
    }
  end
end
