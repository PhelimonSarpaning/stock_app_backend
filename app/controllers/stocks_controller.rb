class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :update, :destroy]

  # # GET /stocks
  # def index
  #   @stocks = Ledger.where(user_id: params[:user_id])
  #
  #   render json: @stocks
  # end
  #
  # # GET /stocks/1
  # def show
  #   render json: @stock.to_json(include: :users)
  # end
  #
  # # POST /stocks
  # def create
  #   @stock = Stock.new(stock_params)
  #
  #   if @stock.save
  #     render json: @stock, status: :created, location: @stock
  #   else
  #     render json: @stock.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # PATCH/PUT /stocks/1
  # def update
  #   if @stock.update(stock_params)
  #     render json: @stock
  #   else
  #     render json: @stock.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # DELETE /stocks/1
  # def destroy
  #   @stock.destroy
  # end

  # Search stocks
  def search
    if (params[:stock])
      looked_up_stock = StockQuote::Stock.quote(params[:stock])
      return nil unless looked_up_stock.name
      @new_stock = looked_up_stock
      # @new_stock = {
      #   ticker: looked_up_stock.symbol,
      #   name: looked_up_stock.name,
      #   ask_price: looked_up_stock.ask,
      #   bid_price: looked_up_stock.bid,
      #   last_trade_price: looked_up_stock.last_trade_price_only
      #
      # }

      if @new_stock
        # render json: @new_stock
        render json: @new_stock 
      else
        render json: {errors: "No record found"}
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def stock_params
      params.require(:stock).permit(:name, :price)
    end
end
