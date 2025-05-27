# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :company

  scope :by_username, -> (username) {
    where('LOWER(username) LIKE ?', "%#{sanitize_sql_like(username.downcase)}%") if username.present?
  }

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
