class SessionsController < ApplicationController

  def new
  end

  def create


    @user = User.find_by_username(params[:username])
      if @user
        if BCrypt::Password.new(@user.password) == params[:password]
          render json: @user, status: :created, location: @user
        else

          render json: {error: "wrong password", success: false}


        end

      else
        #  user is not available
        render json: {error: "No User "}
      end

  end

  def destroy
      session[:username] = nil
  end


end
