class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users.to_json(inlcude: :ledgers)
  end

  # GET /users/1
  def show
    render json: @user.to_json(include: :ledgers)
  end

  # POST /users
  def create

    tempUser = User.find_by_username(params[:username])

    if tempUser
      puts "Username is already taken."
      puts "++++++++++++++++++++++++++++++++"
      render json: {error: "The username is already taken."}
    else

          hashed_password = BCrypt::Password.create(params[:password])
          @user = User.new(user_params)
          @user.name = params[:name]
          @user.username = params[:username]
          @user.password = hashed_password
          @user.money = 10000

          if @user.save
            render json: @user, status: :created, location: @user
          else
            render json: @user.errors, status: :unprocessable_entity
          end
      end


  end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
    if params[:password]!=nil
      hashed_password = BCrypt::Password.create(params[:password])
      @user.password = hashed_password
    end
    if params[:name] != nil
      @user.name = params[:name]
    end
    if params[:money] != nil
      @user.money = params[:money]
    end
    @user.save
    @userStocks = User.find(@user[:id]).ledgers
    render json: {status: 200, user: @user, userstocks: @userStocks}
  end

  # DELETE /users/1

  def destroy
    @user = User.destroy(params[:id])
    render json: {status: 204, user: @user}
  end

  # my_portfolio
  def my_portfolio

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :password, :money)
    end
end
