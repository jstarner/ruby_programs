puts 'Welcome to the Casino!'

def array_gen(array)
	suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
	cards = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King']
	array = []
	count = 0
	count2 = 0
	count3 = 0

	while count < 4
		while count2 < 13
		hash = { suit: suits[count], card: cards[count2], dealt: false}
		array.push(hash)
		#puts array[count3][:suit]
		count2 += 1
		count3 += 1
		end
		count += 1
		count2 = 0
	end
	return array
end

def draw(array, cards)
	number = rand(52)
	if cards == 0
		puts 'There are no more cards in the deck!'
	elsif array[number][:dealt] == true
		draw(array, cards)
	else
		array[number][:dealt] = true
		puts '*' * 60
		puts '*' * 60
		print 'You drew '
		puts array[number][:card] + ' of ' + array[number][:suit]
		puts '*' * 60
		puts '*' * 60
		return array[number]
	end
end

def gameloop(array, user, cards)
	def view_deck(array)
		count3 = 0
		while count3 < 52
			if array[count3][:dealt] == false
				puts array[count3][:card] + ' of ' + array[count3][:suit]
			else
			end
			count3 += 1
		end
	end

	puts 'v - View Deck'
	puts 's - Shuffle Deck'
	puts 'd - Draw a Card'
	puts 'h - View Hand'
	puts 'q - Quit'
	print 'What would you like to do? '

	input = gets.chomp
	input.downcase!

	if input == 'v'
		puts '*' * 60
		puts '*' * 60
		view_deck(array)
		puts '*' * 60
		puts '*' * 60
		puts '-------'
		gameloop(array, user, cards)
	elsif input == 's'
		puts '*' * 60
		puts '*' * 60
		array = array.sort_by{rand}
		puts 'The deck has been shuffled!'
		puts '*' * 60
		puts '*' * 60
		puts '-------'
		gameloop(array, user, cards)
	elsif input == 'd'
		user.push(draw(array, cards))
		cards = cards - 1
		puts '-------'
		gameloop(array, user, cards)
	elsif input == 'h'
		puts '*' * 60
		puts '*' * 60
		puts "You have #{52-cards} cards in your hand!" 
		puts 'Your hand includes the following:'
		count3 = 0
		while count3 < 52
			if array[count3][:dealt] == true
				puts array[count3][:card] + ' of ' + array[count3][:suit]
			else
			end
			count3 += 1
		end
		puts '*' * 60
		puts '*' * 60
		puts '-------'
		gameloop(array, user, cards)
	elsif input == 'q'
		puts 'Goodbye!'
	else
		puts 'Please enter a valid input!'
		gameloop(array, user, cards)
	end
end

array = []
user = []
cards = 52
array = array_gen(array)
gameloop(array, user, cards)
