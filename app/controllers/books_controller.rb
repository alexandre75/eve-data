require 'eve_data.rb'

class BooksController < ApplicationController
  def show
    order_books = EveData.build_market_summary(params)
    render json: order_books, status: :ok, except: [:active_window]
    expires_in 1.hours, public: true
  end
end
