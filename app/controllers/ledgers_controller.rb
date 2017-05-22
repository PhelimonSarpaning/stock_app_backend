class LedgersController < ApplicationController
  before_action :set_ledger, only: [:show, :update, :destroy]

  # GET /ledgers
  def index
    @ledgers = Ledger.all
    render json: @ledgers
  end

  # GET /ledgers/1
  def show
    render json: @ledger
  end

  # POST /ledgers
  def create
    @ledger = Ledger.new(ledger_params)
    stockprice = 0
    # Get current Stock
    stock = params[:stock]
    userId = params[:user][:id]

    # currentUser
    @user = User.find(userId)
    isWatched = params[:isWatched]

    # if the stock is not watched - mean user is buying a stock.
    # if user buys a stock. Need to set USER_ID, QTY, PRICE, Watch= false and a stock symbol
    @ledger.user_id = userId
    @ledger.symbol = stock[:symbol]
    @ledger.watched = isWatched

    if !isWatched
      @userBuyQty = params[:qty]

      if @userBuyQty  < 1
        render json: {errors: "QTY should not be blank."}
      end

      @userFund = @user[:money]
      if stock[:ask]
        @stockprice = stock[:ask]
      else
        @stockprice =  stock[:last_trade_price_only]
      end

      @subSum = @stockprice * @userBuyQty
      if @userFund.to_f.round(2) >= @subSum.to_f.round(2)
        puts "enough money...."

        # need to subtract $ from user fund..
        minusMoney = @userFund.to_f.round(2) - @subSum.to_f.round(2)
        @user[:money] = minusMoney

        # find user stock, with id, symbol, watched = false .. if there is a same stock that user is planning to buy.  Need to add the Order # and money and divide to get the aveage $ which user buys.
        tempstockledger = Ledger.where(user_id: @user[:id], symbol: stock[:symbol], watched: false)

        if tempstockledger.size > 0
          # Update stock
          tempstockledger.each do |x|
            @tempQty = x.qty
            @tempPrice = x.price
            sumTempQtyPrice = @tempQty * @tempPrice
            @weightedAveragePrice = (sumTempQtyPrice + @subSum) / (@tempQty + @userBuyQty)
            @totalShares = @tempQty + @userBuyQty

            # x.price = @weightedAveragePrice.to_f.round(2)
            # x.qty = @totalShares
          end

          Ledger.where(user_id: @user[:id], symbol: @ledger.symbol , watched: false).update_all(price: @weightedAveragePrice.to_f.round(2), qty: @totalShares)

          @userStocks = User.find(@user[:id]).ledgers
             #  save User too.
            @user.save!

              render json: {
                  userstocks: @userStocks,
                  currentUser: @user
               }

        else
          puts "I am in else if there is no duplicate"
          # save new Stock
          @ledger.price = @stockprice
          @ledger.qty = @userBuyQty

          p "@ledger.price" , @ledger.price.to_f.round(2)
          p "@ledger.qty" , @ledger.qty

          if @ledger.save
             @user.save!
             @userStocks = User.find(@user[:id]).ledgers
            #  save User too.
             render json: {
              userstocks: @userStocks,
              currentUser: @user
            }
          else
            render json: @ledger.errors, status: :unprocessable_entity
          end

        end


      else
        render json: {errors: "Not Enough Fund"}
      end

    end
    # if you get this fall you are ok ..
    # new - ledger
  else
    # @ledger.price = 0
    # @ledger.qty = 0
    #
    #
    #   if @ledger.save
    #     @user.save!
    #      @userStocks = User.find(@user[:id]).ledgers
    #     #  save User too.
    #      render json: {
    #        userstocks: @userStocks,
    #        currentUser: @user
    #     }
      # else
      #   render json: @ledger.errors, status: :unprocessable_entity
      # end
  end




  # PATCH/PUT /ledgers/1
  def update
    if @ledger.update(ledger_params)
      render json: @ledger
    else
      render json: @ledger.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ledgers/1
  def destroy
    @ledger.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ledger
      @ledger = Ledger.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ledger_params
      params.require(:ledger).permit(:user_id, :symbol, :qty)
    end
end
