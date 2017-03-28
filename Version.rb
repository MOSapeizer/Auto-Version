class Version
	attr_accessor :x, :y, :z
	def initialize()
		@x = 0
		@y = 0 
		@z = 0
		@position = 'master'
	end

	def digest(action)
		# return nil unless action.is_a? Action end

		@action = action
		case action.type
		when 'checkout'
			@position = action.position
		when 'commit'
			@z = @z + 1
		when 'merge'
			action.position = @position
			if action == merge('feature', to: 'develop')
				@y = @y + 1 
				@z = 0
			end	
			if action == merge('develop', to: 'master')
				@x = @x + 1
				@y = @z = 0
			end
		end
	end

	def merge (from, to: "")
		"merge #{from} to #{to}"
	end

	def to_s
		"#{@x}.#{@y}.#{@z}"
	end
end