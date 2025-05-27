# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'no-reply@socialfeed.com'

  def welcome_email(user)
    @user = user
    @company = user.company
    mail(to: @user.email, subject: "Welcome to #{@company.name}!")
  end
end
