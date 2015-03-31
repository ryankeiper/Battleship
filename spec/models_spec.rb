require 'spec_helper'
require_relative '../lib/controller.rb'

describe Ship do
	it 'can be instantiated' do
	end

	it 'has starting and ending coordinates between (0,0) and (9,9)' do
	end

	it 'has a length between 1 and 10' do
	end

	it 'has coordinates that match its length' do
	end

	it 'can take damage' do
	end

	it 'can store its location in the current game table in ActiveRecord' do
	end

	it 'can store its damage in the current game table in ActiveRecord' do
	end
end

describe Grid do
	it 'can be instantiated' do
	end

	it 'has an array of coordinate point arrays' do
	end

  context 'during a game' do

  	it 'can take user input for torpedo shot coordinates' do
  	end

	it 'can compare torpedo shots with ship locations and produce a hit' do
	end

	it 'can compare torpedo shots with ship locations and produce a miss' do
	end

	it 'can store the location of all guesses to the current game in ActiveRecord' do
	end

  end
end

describe Stats do
	it 'can display turns remaining' do
	end

	it 'can display total hits given and received' do
	end

	it 'can store data to current game db with ActiveRecord' do
	end
end

describe Menu do
	it 'can be instantiated' do
	end

	it 'can return to a previously unfinished game' do
	end

	it 'can clear a previously unfinished game to start a new game' do
	end
end





