class Port < ActiveRecord::Base

	include Geolocation
	include Content
	include Imageable

	has_many :port_of_calls, dependent: :destroy, inverse_of: :port
	has_many :cruises, through: :port_of_calls

	has_many :cruise_list_ports, dependent: :destroy
	has_many :cruises, through: :cruise_list_ports

	default_scope { order(name: :asc) }

	extend FriendlyId
	friendly_id :name, use: :slugged

	def should_generate_new_friendly_id?
		slug.blank?
	end

	geocoded_by :name
	after_validation { geocode_conditionals(:name) }

	validates :name, presence: true

end
