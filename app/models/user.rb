class User < ApplicationRecord
  belongs_to :company

  scope :by_username, -> (username) { where('username LIKE ?', username) if username.present? }
end
