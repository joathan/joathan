class User < ApplicationRecord
  belongs_to :company

  scope :by_username, -> (username) {
    where('LOWER(username) LIKE ?', "%#{sanitize_sql_like(username.downcase)}%") if username.present?
  }
end
