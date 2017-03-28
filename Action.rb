class Action
	attr_accessor :type, :from, :position, :identify
	def initialize(message)
		messages = message.split(':', 3)
		self.hash_timestamp = messages[0].strip
		self.action = messages[1].strip
		self.message = messages[2].strip
	end

	def to_s
		return "#{type} to #{position}" if @from.nil? || @from.empty?
		@from = @from.split('/')[0]
		"#{type} #{from} to #{position}"
	end

	def full_info
		"#{identify} #{self.to_s}"
	end

	def ==(val)
		self.to_s == val
	end

	private
	def action=(val)
		@type, @from = val.split(' ')
	end

	def message=(val)
		@position = val.split(' ')[-1]
	end

	def hash_timestamp=(val)
		group = val.split(" ")
		@identify = { hash: group[0], timestamp: group[1].match(/^HEAD\@\{([\d]*)\}$/)[1] }
	end
end