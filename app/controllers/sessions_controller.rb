class SessionsController < ApplicationController

  def new
  end

  def create
    p "++++++++++++++++++++++"
    puts params[:username]
    p "+++++++++++++++++++++"
    render 'new'
  end

  def destroy
  end

  # def login
  #   @user = User.find_by_username(params[:username])
  #   if @user.password == params[:password]
  #     puts " -- user login ok "
  #     render json: @user
  #     # give_token
  #   else
  #     # redirect_to home_url
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end

end
