require 'finnhub_ruby'

class Stock < ApplicationRecord
  attr_accessor :ticker_symbol
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    stock = find_by(ticker: ticker_symbol)

    unless stock
      FinnhubRuby.configure do |config|
        config.api_key['api_key'] = 'chjhig9r01qh5480h190chjhig9r01qh5480h19g' # Replace with your actual API key
      end

      finnhub_client = FinnhubRuby::DefaultApi.new
      quote = finnhub_client.quote(ticker_symbol)
      company_profile = finnhub_client.company_profile2(symbol: ticker_symbol)

      stock = new(
        ticker: ticker_symbol,
        name: company_profile.name,
        last_price: quote.c
      )
    end

    stock
  end
  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

end
