# require_relative "lib/controller.rb"

# Run.new
require 'pry'

class Account
	def initialize current_balance = 0
		@current_balance = current_balance
	end

	def display_balance
		return @current_balance
	end
end

binding.pry


# [9,5]
# 5.times do
# 	system "clear"
# 	puts "It's a hit!!"
# 	sleep 0.2
# 	system "clear"
# 	puts " "
# 	sleep 0.2
# end