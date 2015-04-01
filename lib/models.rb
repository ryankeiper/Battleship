require 'pry'
require 'active_record'

ActiveRecord::Base.establish_connection(
	database: 'battleship',
	host: 'localhost',
	adapter: 'postgresql'
)

class Ship < ActiveRecord::Base
	attr_reader :length
	attr_accessor :damage, :sunk, :ship_coord

	belongs_to :player

	def setup
		@length = 5
		@ship_coord = []
		@damage = 0
		@sunk = false
	end

	def place_horizontal start_coord, direction = nil
		if start_coord[0] < 4 || direction == 'l'
			counter = 0
			while counter < @length
				ship_coord = [(start_coord[0] + counter), start_coord[1]]
				@ship_coord << ship_coord
				counter += 1
			end
		elsif start_coord[0] > 5 || direction == 'r'
			counter = 4
			while @length - counter <= @length
				ship_coord = [(start_coord[0] - counter), start_coord[1]]
				@ship_coord << ship_coord
				counter -= 1
			end
		end
		return @ship_coord
	end

	def place_vertical start_coord, direction = nil
		if start_coord[1] < 4 || direction == 'u'
			counter = 0
			while counter < @length
				ship_coord = [start_coord[0], (start_coord[1] + counter)]
				@ship_coord << ship_coord
				counter += 1
			end
		elsif start_coord[1] > 5 || direction == 'd'
			counter = 4
			while @length - counter <= @length
				ship_coord = [start_coord[0], (start_coord[1] - counter)]
				@ship_coord << ship_coord
				counter -= 1
			end
		end
		return @ship_coord
	end

	def hit_check coords
		if @ship_coord.include? coords
			@damage += 1
			if @damage >= @length
				@sunk = true
			end
			return true
		else
			return false
		end
	end
end

class Grid
	attr_reader :coordinates
	def initialize
		coordinates = []
		x = 0
		y = 0
		while x < 10
			while y < 10
				coordinate = [x, y]
				coordinates << coordinate
				y += 1
			end
			y = 0
			x += 1
		end
		@coordinates = coordinates
	end
end

class CreateGrid < ActiveRecord::Migration
	def initialize
		create_table :ships do |column|
			column.integer :length
			column.integer :x_axis
			column.integer :y_axis
			column.integer :damage
			column.boolean :sunk
		end

		create_table :guesses do |column|
			column.integer :x_axis
			column.integer :y_axis
			column.integer :turn
		end
	end
end

CreateGrid.new


#binding.pry







