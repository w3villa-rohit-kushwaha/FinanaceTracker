class StocksController < ApplicationController
  def search
    @stock = Stock.new_lookup(params[:stock])

    if @stock.present? && @stock.last_price.present? && @stock.name.present? && @stock.ticker.present?
      render 'users/my_portfolio'
    else
      flash.now[:alert] = 'Stock not found or incomplete data'
      render 'users/my_portfolio'
    end
  end
end
