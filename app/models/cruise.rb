class Cruise < ActiveRecord::Base

	# includes and requirements
	include Content
	# include Imageable

	# include DatetimeFormat
	# datetime_vars start_var: :start_at, end_var: :end_at

	# assocations
	belongs_to :venue, inverse_of: :cruises
	has_many :port_of_calls, dependent: :destroy, inverse_of: :cruise
	has_many :ports, through: :port_of_calls

	accepts_nested_attributes_for :port_of_calls, reject_if: proc { |attributes| attributes['port_id'].blank? }, allow_destroy: true

	# scopes
	# default_scope { includes(:port_of_calls).where("DATE(start_at) > ?", Date.today ).order(start_at: :asc) }
	default_scope { order(start_at: :asc) }

	scope :future, -> { where("start_at > ?", Time.now) }

	scope :has_image, -> { joins(ports: :pictures).distinct }

	# validations
	validates :venue_id, presence: true
	validates :port_of_calls, length: { minimum: 2, message: "requires %{count} or more. Go back to add more." }
	validates_associated :port_of_calls, message: 'are invalid. Go back to edit.'

	# callbacks
	after_save :update_times

	# class methods
	def pictures
		pics = Picture.where(imageable: self.ports)
		pics.order(reorder_pictures) unless pics.nil?
	end

	def featured_port
		if self.port_of_calls.any?
			unless fport = self.port_of_calls.find_by(featured: true)
				fport = self.port_of_calls.second
			end
			fport.port
		end
	end

	# instance methods
	def night_length
		(end_at.to_date - start_at.to_date).to_i
	end

	def date_span
		self.start_at.strftime("%b %d, %Y") + ' - ' + self.end_at.strftime("%b %d, %Y")
	end


	# filters
	def update_times
		pocs = self.port_of_calls.order(departs_at: :desc)
		self.update_column(:start_at, pocs.first.departs_at)
		self.update_column(:end_at, pocs.last.arrives_at)
	end

	def reorder_pictures
		mod_port_ids = self.port_of_calls.drop(1).map{ |p| p.port.pictures.any? ? p.port.pictures.first.id : 0 }
		out = "CASE"
		mod_port_ids.each_with_index do |id, i|
			out << " WHEN id = #{id} THEN #{i}"
		end
		out << " END"
	end

	def icon
		'ship'
	end

end
