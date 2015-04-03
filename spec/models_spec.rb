require 'spec_helper'
require_relative '../lib/controller.rb'

describe Ship do
	before :each do
		@ship = Ship.new
	end

	it 'has a length between 1 and 10' do
		expect(@ship.length).to be < 10
		expect(@ship.length).to be > 0
	end

	it 'can be placed horizontally' do 
		@ship.place_horizontal [4,2], 'l'
		expect(@ship.ship_coord).to match_array([[4,2], [5,2], [6,2], [7,2], [8,2]])
	end

	it 'can be placed vertically' do 
		@ship.place_vertical [5,5], 'u'
		expect(@ship.ship_coord).to match_array([[5,5], [5,6], [5,7], [5,8], [5,9]])
	end
	
	it 'can take damage' do
		@ship.place_vertical [2,2]
		expect(@ship.hit_check [2,6]).to be(true)
	end

# 	it 'can store its location in the current game table in ActiveRecord' do
# 	end

# 	it 'can store its damage in the current game table in ActiveRecord' do
# 	end
end

describe Grid do
	before :each do
		@grid = Grid.new
	end
	it 'can be instantiated' do
		expect(@grid).to be_a(Grid)
	end

	it 'has an array of coordinate point arrays' do
		expect(@grid.coordinates.count).to be(100)
		expect(@grid.coordinates[0].count).to be(2)
	end

 #  context 'during a game' do

 #  	it 'can take user input for torpedo shot coordinates' do
 #  	end

	# it 'can compare torpedo shots with ship locations and produce a hit' do
	# end

	# it 'can compare torpedo shots with ship locations and produce a miss' do
	# end

	# it 'can store the location of all guesses to the current game in ActiveRecord' do
	# end

 #  end
end

# describe Turn do
# 	xit 'can take coordinates for a user guess'
# 	@turn = Turn.new
# 	expect(@turn).to eql()
# end

# describe Stats do
# 	it 'can display turns remaining' do
# 	end

# 	it 'can display total hits given and received' do
# 	end

# 	it 'can store data to current game db with ActiveRecord' do
# 	end
# end

# describe Menu do
# 	it 'can be instantiated' do
# 	end

# 	it 'can return to a previously unfinished game' do
# 	end

# 	it 'can clear a previously unfinished game to start a new game' do
# 	end
# end





