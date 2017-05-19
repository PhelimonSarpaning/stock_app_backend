require 'jwt'
class SessionsController < ApplicationController

  def new
  end

  def create


    @user = User.find_by_username(params[:username])
      if @user
        if BCrypt::Password.new(@user.password) == params[:password]

         # ..... Testing user stock
         @stocks = []
         userStocks = ['V', 'F', 'GOOG' 'YHOO']
         puts "***************"
         userStocks.each do |stockValue|
           looked_up_stock = StockQuote::Stock.quote(stockValue)
           tempStock = {
             name: looked_up_stock.name,
             symbol: looked_up_stock.symbol
           }
          @stocks.push(tempStock)
         end


           puts @stocks

           puts "***************"

          payload = {data: @user.username}
          hmac_secret = 'our$ecretTrading$tockApp'
          @token  = JWT.encode payload, hmac_secret, 'HS256'

          puts @token

          render json: {
            user:  @user,
            token:  @token
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
