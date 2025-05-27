# frozen_string_literal: true

module Tweets
  class Fetcher
    DEFAULT_LIMIT = 10

    def initialize(username:, cursor:, limit:)
      @username = username
      @cursor = cursor.presence&.to_i
      @limit = limit.presence&.to_i || DEFAULT_LIMIT
    end

    def call
      scope = Tweet.recent_first
      scope = scope.by_user_username(@username)
      scope = scope.where("id < ?", @cursor) if @cursor.present?
      scope.limit(@limit)
    end
  end
end
