require 'jwt'
class SessionsController < ApplicationController

  def new
  end

  def create


    @user = User.find_by_username(params[:username])
      if @user
        if BCrypt::Password.new(@user.password) == params[:password]

         # ..... Testing user stock
        #  @stocks = []
        #  Get User Stocks
         @userStocks = User.find(@user.id).ledgers
        #  p userStocks
        #  userStocks.each do |s|
        #    tempStock = {
        #      name: s.name,
        #      symbol: s.symbol,
        #      price: s.price,
        #      qty: s.qty,
        #      isWatched: s.watched
        #    }
        #   @stocks.push(tempStock)
         #
        #  end
# looked_up_stock = StockQuote::Stock.quote(stockValue)
         # 
        #  puts "***************"
         #
         #
        #    puts @stocks
         #
        #   puts "***************"


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
