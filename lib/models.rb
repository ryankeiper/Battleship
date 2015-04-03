require 'pry'
require 'active_record'

ActiveRecord::Base.establish_connection(
	database: 'battleship',
	host: 'localhost',
	adapter: 'postgresql'
)

class Game < ActiveRecord::Base
	has_many :players
	has_many :turns
	has_many :ships, through: :players

end

class Player < ActiveRecord::Base
	has_one :game
	has_many :ships
	has_many :turns

	validates_presence_of :name
end

class Turn <ActiveRecord::Base
	belongs_to :player

	validates_presence_of :turn_num, :shot
end

class Ship #< ActiveRecord::Base
	#belongs_to :player

	#validates_presence_of :length, :ship_coord, :damage, :sunk
	attr_reader :ship_coord
	def initialize
		@length = 5
		@ship_coord = []
		@damage = 0
		@sunk = false
	end

	def place_horizontal start_coord, direction = nil, display
		if start_coord[0] < 4 || direction == 'l'
			counter = 0
			while counter < @length
				ship_coord = [start_coord[0], (start_coord[1] + counter)]
				@ship_coord << ship_coord
				counter += 1
			end
		elsif start_coord[0] > 5 || direction == 'r'
			counter = 4
			while @length - counter <= @length
				ship_coord = [start_coord[0], (start_coord[1] - counter)]
				@ship_coord << ship_coord
				counter -= 1
			end
		end
		display[@ship_coord[0].join("").to_i] = "<"
		display[@ship_coord[1].join("").to_i] = "Z"
		display[@ship_coord[2].join("").to_i] = "@"
		display[@ship_coord[3].join("").to_i] = "Z"
		display[@ship_coord[4].join("").to_i] = ">"
	end

	def place_vertical start_coord, direction = nil, display
		if start_coord[1] < 4 || direction == 'u'
			counter = 0
			while counter < @length
				ship_coord = [(start_coord[0] + counter), start_coord[1]]
				@ship_coord << ship_coord
				counter += 1
			end
		elsif start_coord[1] > 5 || direction == 'd'
			counter = 4
			while @length - counter <= @length
				ship_coord = [(start_coord[0] - counter), start_coord[1]]
				@ship_coord << ship_coord
				counter -= 1
			end
		end
		display[@ship_coord[0].join("").to_i] = "A"
		display[@ship_coord[1].join("").to_i] = "H"
		display[@ship_coord[2].join("").to_i] = "@"
		display[@ship_coord[3].join("").to_i] = "H"
		display[@ship_coord[4].join("").to_i] = "V"
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

def new_ship
	ship = Ship.new
	ship.length = 5
	ship.ship_coord = []
	ship.damage = 0
	ship.sunk = false
	return ship
end

class CreateGame < ActiveRecord::Migration
	def initialize
		create_table :games do |column|
		end

		create_table :players do |column|
			column.string :name
		end

		create_table :turns do |column|
			column.integer :turn_num
			column.string :shot
		end

		create_table :ships do |column|
			column.integer :length
			column.string :ship_coord
			column.integer :damage
			column.boolean :sunk
		end
	end
end

def grid
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
	return coordinates
end

def display
	display_grid = []
	100.times do
		display_grid << " "
	end
	return display_grid
end

def enemy_grid display
	i = 0
	j = 0
	puts "------ The Enemy -----"
	puts " |0|1|2|3|4|5|6|7|8|9|"                                    # | | | | | | | | | |"
	while j < 10
		print j
		while i < 10
			print "|#{display[(j*10) + i]}"
			i += 1
		end
		puts "|"
		i = 0
		j += 1
	end
end

def hero_grid display
	i = 0
	j = 0
	puts "---- You, The Hero ---"
	puts " |0|1|2|3|4|5|6|7|8|9|"                                    # | | | | | | | | | |"
	while j < 10
		print j
		while i < 10
			print "|#{display[(j*10) + i]}"
			i += 1
		end
		puts "|"
		i = 0
		j += 1
	end
end

hero_display = display
enemy_display = display

#binding.pry







