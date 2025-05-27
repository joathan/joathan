# frozen_string_literal: true

class UsersController < ApplicationController

  def index
    if params[:company_id]
      company = Company.find(params[:company_id])
      users = company.users
    else
      users = User.all
    end

    users = users.by_username(search_params[:username])

    render json: users
  end

  private

  def search_params
    params.permit(:username)
  end

end
