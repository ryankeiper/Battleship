require 'pry'
require 'active_record'

ActiveRecord::Base.establish_connection(
	database: 'battleship',
	host: 'localhost',
	adapter: 'postgresql'
)

class Ship
	attr_reader :ship_coord, :sunk
	def initialize
		@length = 5
		@ship_coord = []
		@damage = 0
		@sunk = false
	end

	def place_horizontal start_coord, direction = nil, display
		if start_coord[1] < 4 || direction == 'l'
			counter = 0
			while counter < @length
				ship_coord = [start_coord[0], (start_coord[1] + counter)]
				@ship_coord << ship_coord
				counter += 1
			end
		elsif start_coord[1] > 5 || direction == 'r'
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
		if start_coord[0] < 4 || direction == 'u'
			counter = 0
			while counter < @length
				ship_coord = [(start_coord[0] + counter), start_coord[1]]
				@ship_coord << ship_coord
				counter += 1
			end
		elsif start_coord[0] > 5 || direction == 'd'
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

def hit_animation
	5.times do
	system "clear"
	puts "It's a hit!!"
	sleep 0.2
	system "clear"
	puts " "
	sleep 0.2
	end		
end

def win_animation
	5.times do
	system "clear"
	puts "We have defeated the enemy Admiral!!"
	sleep 0.2
	system "clear"
	puts " "
	sleep 0.2
	end		
end

def loss_animation
	5.times do
	system "clear"
	puts "We have been defeated Admiral!!"
	sleep 0.2
	system "clear"
	puts " "
	sleep 0.2
	end		
end

def new_ship
	ship = Ship.create(:length => 5, :damage => 0, :sunk => false)
	ship.length = 5
	ship.ship_coord = []
	ship.damage = 0
	ship.sunk = false
	return ship
end

def populate_enemy_ships
	enemy_ships = []
	new_display = display
	loop do
		while enemy_ships.count != 2
			x = rand(10).floor
			y = rand(10).floor
			l_or_r = rand
			u_or_d = rand
			h_or_v = rand
			if l_or_r > 0.5
				l_or_r = "l"
			else
				l_or_r = "r"
			end
			if u_or_d > 0.5
				u_or_d = "u"
			else
				u_or_d = "d"
			end
			if h_or_v > 0.5
				h_or_v = "h"
			else
				h_or_v = "v"
			end
			if h_or_v == "h"
				if y == 4 || y == 5
					enemy_ships << Ship.new
					enemy_ships.last.place_horizontal [x,y], l_or_r, new_display
				else
					enemy_ships << Ship.new
					enemy_ships.last.place_horizontal [x,y], new_display
				end
			elsif h_or_v == "v"
				if x == 4 || x == 5
					enemy_ships << Ship.new
					enemy_ships.last.place_vertical [x,y], u_or_d, new_display
				else
					enemy_ships << Ship.new
					enemy_ships.last.place_vertical [x,y], new_display
				end
			end
		end
		compare = enemy_ships[0].ship_coord & enemy_ships[1].ship_coord
		if compare == []
			break
		else
			enemy_ships = []
			new_display = display
		end
	end
	return enemy_ships
end

def hero_shot coord, enemy_display, hero_shots
	enemy_display[coord.join("").to_i] = "*"
	hero_shots << coord
end

def enemy_shot hero_display, enemy_shots
	loop do
		x = rand(10).floor
		y = rand(10).floor
		coord = [x,y]
		coords = []
		coords << coord
		if enemy_shots & coords == []
			hero_display[coord.join("").to_i] = "*"
			enemy_shots << coord
			break
		end
	end
	return enemy_shots
end

class CreateGame < ActiveRecord::Migration
	def initialize
		create_table :displays do |column|
			column.string :display
		end

		create_table :turns do |column|
			column.integer :turn
		end

		create_table :shots do |column|
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









