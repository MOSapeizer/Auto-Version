require 'Set'

class IdentitySet < Set
	def include?(hash)
		self.each do |id|
			return true if id[:hash] == hash
		end
		false
	end
end