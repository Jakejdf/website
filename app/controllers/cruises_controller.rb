class CruisesController < ApplicationController

	before_action :set_cruise, only: [:show]

	def index
		@background_image = 'bg-water.jpg'
		@cruises = Cruise.future.has_image.page(params[:page]).per(15)
	end

	def show
	end

	private

	def set_cruise
		@cruise = Cruise.find(params[:id])
	end

end
