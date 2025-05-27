# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    company = Company.first || Company.create!(name: "Preview Corp")
    user = User.where(email: "preview@example.com").first_or_create!(
      username: "preview",
      display_name: "Preview User",
      email: "preview@example.com",
      company: company
    )

    UserMailer.welcome_email(user)
  end
end
