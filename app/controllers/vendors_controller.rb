class VendorsController < ApplicationController
  def show
    vendor_response = Faraday.get("http://localhost:3000/api/v0/vendors/#{params[:id]}")
    @vendor = JSON.parse(vendor_response.body, symbolize_names: true)[:data]
    @markets = []
  end

  def search_markets
    
    response = Faraday.get("http://localhost:3000/api/v0/vendors/#{params[:id]}")
    @vendor = JSON.parse(response.body, symbolize_names: true)[:data]

    
    if params[:name].blank? && params[:city].blank? && params[:state].blank?
      flash[:alert] = "Please provide at least one search criterion."
      redirect_to vendor_path(@vendor[:id])
    else
      
      response = Faraday.get("http://localhost:3000/api/v0/markets", { name: params[:name], city: params[:city], state: params[:state] })
      @markets = JSON.parse(response.body, symbolize_names: true)[:data]
      
      if @markets.present?
        flash.now[:notice] = "Search completed successfully."
      else
        flash.now[:alert] = "No markets found with the provided criteria."
      end
      render :show
    end
  end

  def add_market
      market_id = params[:market_id]
      vendor_id = params[:id]

    
      response = Faraday.post("http://localhost:3000/api/v0/market_vendors", {
        market_id: market_id,
        vendor_id: vendor_id
      }.to_json, 'Content-Type' => 'application/json')

      if response.status == 201
        flash[:notice] = "Successfully added vendor to market"
      elsif response.status == 422
        flash[:alert] = "Vendor is already associated with this market"
      else
        flash[:alert] = "There was an issue adding the vendor to the market"
      end

      redirect_to vendor_path(vendor_id)
   end
end
