require 'jwt'
class SessionsController < ApplicationController

  def new
  end

  def create


    @user = User.find_by_username(params[:username])
      if @user
        if BCrypt::Password.new(@user.password) == params[:password]

         # ..... Get user stock
         @userStocks = User.find(@user.id).ledgers

          # get token
          payload = {data: @user.username}
          hmac_secret = 'our$ecretTrading$tockApp'
          @token  = JWT.encode payload, hmac_secret, 'HS256'

          puts @token

          render json: {
            user:  @user,
            token:  @token,
            userstocks: @userStocks
         }

        else

          render json: {error: "wrong password", success: false}
        end

      else
        #  user is not available
        render json: {error: "wrong username"}
      end

  end

  def destroy
      session[:username] = nil
  end


end
