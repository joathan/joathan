class Tweet < ApplicationRecord
  belongs_to :user

  scope :by_user_username, ->(username) {
    joins(:user).where(users: { username: username }) if username.present?
  }
end
