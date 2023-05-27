require 'httparty'

class WelcomeController < ApplicationController
  def index
    @stock_news = fetch_stock_news
  end

  private

  def fetch_stock_news
    api_key = '4d940f1e6a4748c5b8fc4e95d2038da3'
    url = "https://newsapi.org/v2/everything?q=stock&apiKey=#{api_key}"

    response = HTTParty.get(url)
    news_data = JSON.parse(response.body)

    news_data['articles'].select { |article| article['urlToImage'].present? }
  end


end
