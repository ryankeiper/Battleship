require 'pry'
require_relative 'models'
def opening
	system "clear"
	puts "        !!!!!!BATTLESHIP!!!!!!       # #  ( )"
	puts "                                  ___#_#___|__"
	puts "                              _  |____________|  _"
	puts "                       _=====| | |            | | |==== _"
	puts "                 =====| |.---------------------------. | |===="
	puts "   <--------------------'   .  .  .  .  .  .  .  .   '--------------/"
	puts "    \\                                                             /"
	puts "     \\___________________________________________________________/"
	puts "  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
	puts "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
	puts "   wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww "

	sleep 3
	system "clear"
end

opening

hero_display = display
enemy_display = display
hero_ships = []
enemy_ships = []
hero_shots = []
enemy_shots = []

loop do
	system "clear"
	puts "******************************************************"
	puts "********************* Battleship *********************"
	puts "******************************************************"
	puts "--------------------- Main Menu ----------------------"
	puts " "
	puts "1. New Game"
	puts "2. Load Game"
	puts "3. Exit"
	puts " "
	puts "Make your choice, Admiral!"
	user_choice = gets.chomp

	case user_choice
	when "1"
		while hero_ships.length < 2
			system "clear"
			enemy_grid enemy_display
			puts " "
			hero_grid hero_display
			puts " "
			puts "How shall we position this ship, Admiral?"
			puts "Type H for horizontal, or V for vertical:"
			h_or_v = gets.chomp.downcase
			puts "Where shall we place the head of the ship?"
			puts "X-coordinate:"
			y = gets.chomp.to_i
			puts "Y-coordinate:"
			x = gets.chomp.to_i
			if (h_or_v != "h" && h_or_v != "v") || x < 0 || x > 9 ||  y < 0 || y > 9
				puts "I didn't understand your input Admiral!"
				sleep 3
			elsif h_or_v == "h"
				if y == 4 || y == 5
					puts "Will she face to the left or the right, Admiral?"
					puts "Type L for left, or R for right"
					left_or_right = gets.chomp.downcase
					if left_or_right != "l" && left_or_right != "r"
						puts "I didn't understand your input Admiral!"
						sleep 3
					end
					hero_ships << Ship.new
					hero_ships.last.place_horizontal [x,y], left_or_right, hero_display
					if hero_ships.count == 2
						compare = hero_ships[0].ship_coord & hero_ships[1].ship_coord
						if compare == []
							puts "Our sonar indicates the enemy is placing a ship..."
							sleep 3
						else
							puts "We already have a ship in that position Admiral! There was a collision!"
							hero_ships = []
							hero_display = display
							sleep 3
						end
					else
						puts "Our sonar indicates the enemy is placing a ship..."
						sleep 3
					end
				else
					hero_ships << Ship.new
					hero_ships.last.place_horizontal [x,y], hero_display
					if hero_ships.count == 2
						compare = hero_ships[0].ship_coord & hero_ships[1].ship_coord
						if compare == []
							puts "Our sonar indicates the enemy is placing a ship..."
							sleep 3
						else
							puts "We already have a ship in that position Admiral! There was a collision!"
							hero_ships = []
							hero_display = display
							sleep 3
						end
					else
						puts "Our sonar indicates the enemy is placing a ship..."
						sleep 3
					end
				end
			elsif h_or_v == "v"
				if x == 4 || x == 5
					puts "Will she face up or down, Admiral?"
					puts "Type U for up, or D for down"
					up_or_down = gets.chomp.downcase
					if up_or_down != "u" && up_or_down != "d"
						puts "I didn't understand your input Admiral!"
						sleep 3
					end
					hero_ships << Ship.new
					hero_ships.last.place_vertical [x,y], up_or_down, hero_display
					if hero_ships.count == 2
						compare = hero_ships[0].ship_coord & hero_ships[1].ship_coord
						if compare == []
							puts "Our sonar indicates the enemy is placing a ship..."
							sleep 3
						else
							puts "We already have a ship in that position Admiral! There was a collision!"
							hero_ships = []
							hero_display = display
							sleep 3
						end
					else
						puts "Our sonar indicates the enemy is placing a ship..."
						sleep 3
					end
				else
					hero_ships << Ship.new
					hero_ships.last.place_vertical [x,y], hero_display
					if hero_ships.count == 2
						compare = hero_ships[0].ship_coord & hero_ships[1].ship_coord
						if compare == []
							puts "Our sonar indicates the enemy is placing a ship..."
							sleep 3
						else
							puts "We already have a ship in that position Admiral! There was a collision!"
							hero_ships = []
							hero_display = display
							sleep 3
						end
					else
						puts "Our sonar indicates the enemy is placing a ship..."
						sleep 3
					end
				end
			end
		end
		enemy_ships = populate_enemy_ships
		turn = 1
		loop do
			loop do
				system "clear"
				enemy_grid enemy_display
				puts " "
				hero_grid hero_display
				puts "Turn: #{turn}"
				puts "Awaiting torpedo coordinates, Admiral!"
				puts "X-coordinate:"
				y = gets.chomp.to_i
				puts "Y-coordinate:"
				x = gets.chomp.to_i
				coords = []
				coords << [x,y]
				if coords & hero_shots == []
					puts "Torpedo away!!"
					sleep 2
					hero_shot [x,y], enemy_display, hero_shots
					check_ship1 = enemy_ships[0].hit_check [x,y]
					check_ship2 = enemy_ships[1].hit_check [x,y]
					if check_ship1 == true || check_ship2 == true
						hit_animation
						if enemy_ships[0].sunk == true && enemy_ships[1].sunk == true
							win_animation
							exit
						end
					end
					break
				else
					puts "We've already fired there, Admiral!"
					sleep 2
				end
			end
			system "clear"
			enemy_grid enemy_display
			puts " "
			hero_grid hero_display
			puts "Turn: #{turn}"
			puts "The enemy is returning fire Admiral!"
			sleep 4
			enemy_shots = enemy_shot hero_display, enemy_shots
			check_ship1 = hero_ships[0].hit_check enemy_shots.last
			check_ship2 = hero_ships[1].hit_check enemy_shots.last
				if check_ship1 == true || check_ship2 == true
					hit_animation
					if hero_ships[0].sunk == true && hero_ships[1].sunk == true
						loss_animation
						exit
					end
				end
			turn += 1
		end
	when "2"

	when "3"
		system "clear"
		puts "We await your return, Admiral."
		exit
	else
		puts "Did not copy that last transmission Admiral! Say again, over."
		sleep 2
	end
end






#binding.pry