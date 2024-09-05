class MarketsController < ApplicationController
  def index
    response = Faraday.get('http://localhost:3000/api/v0/markets')
    @markets = JSON.parse(response.body, symbolize_names: true)[:data]
  end

  def show
    market_response = Faraday.get("http://localhost:3000/api/v0/markets/#{params[:id]}")
    @market = JSON.parse(market_response.body, symbolize_names: true)[:data]

    vendors_response = Faraday.get("http://localhost:3000/api/v0/markets/#{params[:id]}/vendors")
    @vendors = JSON.parse(vendors_response.body, symbolize_names: true)[:data]
  end
end
