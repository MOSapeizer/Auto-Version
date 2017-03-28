#!/usr/local/bin/ruby -w

require 'Set'
require_relative 'Action'
require_relative 'IdentitySet'
require_relative 'Version'

current_hash = `git log --pretty=format:'%h' -n 1`.delete("\n")
current_timestamp = `git log --pretty=format:'%ct' -n 1`.delete("\n")

master_hashes = `git checkout master &> /dev/null;
				 git log --pretty=format:'%h %ct'; 
				 git checkout #{current_hash} &> /dev/null`.split("\n")

current_hashes = `git log --pretty=format:'%h %ct';`.split("\n")

parse_hash_timestamp = -> hash_timestamp {
	hash_timestamp_pair = hash_timestamp.split(" ")
	{ hash: hash_timestamp_pair[0], timestamp: hash_timestamp_pair[1] }
}

hash_timestamp_group = IdentitySet.new
hash_timestamp_group = hash_timestamp_group + master_hashes.map(&parse_hash_timestamp).to_set
hash_timestamp_group = hash_timestamp_group + current_hashes.map(&parse_hash_timestamp).to_set
hash_timestamp_group.select! do |record|
	record[:timestamp] <= current_timestamp
end

merges = `git reflog --date=unix | awk '!seen[$0]++'`.split("\n")
references = merges.reverse!.map { |message| Action.new(message) }
references.select! do |ref|
	hash_timestamp_group.include?(ref.identify[:hash]) && ref.identify[:timestamp] <= current_timestamp
end

version = Version.new
references.each do |action|
	version.digest action
end

puts version


