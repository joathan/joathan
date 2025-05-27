# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#welcome_email" do
    let(:company) { Company.create!(name: "Test Corp") }
    let(:user) { User.create!(display_name: "João", username: "joao", email: "joao@example.com", company: company) }
    let(:mail) { described_class.welcome_email(user) }

    it "renders the subject" do
      expect(mail.subject).to eq("Welcome to #{company.name}!")
    end

    it "sends to the user's email" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["no-reply@socialfeed.com"])
    end

    it "assigns @user in the body" do
      plain_body = mail.parts.find { |p| p.content_type.include?('text/plain') }&.decoded
      html_body  = mail.parts.find { |p| p.content_type.include?('text/html') }&.decoded

      expect(plain_body).to include(user.display_name)
      expect(html_body).to include(user.display_name)
    end

    it "assigns @company in the body" do
      expect(mail.body.encoded).to match(company.name)
    end
  end
end
