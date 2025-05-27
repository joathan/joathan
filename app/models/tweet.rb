# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user

  scope :by_user_username, ->(username) {
    joins(:user).where(users: { username: username }) if username.present?
  }
  scope :recent_first, -> { order(created_at: :desc) }
end
