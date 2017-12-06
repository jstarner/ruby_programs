def print_with_stars(string)
	puts '*' * 60
	puts '*' * 60
	puts string
	puts '*' * 60
	puts '*' * 60
end

print_with_stars('Welcome to the Casino!')

def create_deck_of_cards_array
	suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
	cards = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King']
	value = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
	deck_of_cards = []

	suits.each do |suit|
		13.times do |y|
		deck_of_cards.push({suit: suit, card: cards[y], dealt: false, value: value[y]})
		end
	end
	return deck_of_cards
end

def viewhand(hand, string)
	count3 = 0
	count4 = 0
	while count3 < hand.length
		if hand[count3][:dealt] == true
			string += hand[count3][:card] + ' of ' + hand[count3][:suit] + "\n"
			count4 += hand[count3][:value]
		else
		end
		count3 += 1
	end
	return count4, string
end

def handcount(array)
	count3 = 0
	count4 = 0
	while count3 < array.length
		if array[count3][:dealt] == true
			count4 += array[count3][:value]
		else
		end
		count3 += 1
	end
	return count4
end

def dealer(count)
	number = rand(4)
	number = 21 - number
	if count == number
		return "You and the dealer both had #{number}, it's a tie!"
	elsif count < number
		return "The dealer had #{number} and you had #{count}, you lose!"
	else count > number
		return "The dealer had #{number} and you had #{count}, you win!"
	end
end

def draw(current_deck, cards)
	number = rand(52)
	if cards == 50
		return current_deck[number]
	elsif current_deck[number][:dealt] == true
		draw(current_deck, cards)
	else
		current_deck[number][:dealt] = true
		puts current_deck[number][:card] + ' of ' + current_deck[number][:suit]
		cards = cards - 1
		draw(current_deck, cards)
	end
end

def drawone(array, cards, count)
	bust = false
	number = rand(52)
	if array[number][:dealt] == true
		draw(array, cards)
	else
		array[number][:dealt] = true
		puts 'Your were dealt: '
		puts array[number][:card] + ' of ' + array[number][:suit]
		value = array[number][:value] + count
		puts "Your cards add up to #{value} points!"
		if value > 21
			puts "Oh no! Your total is now #{value} which is greater than 21, you lose!"
			bust = true
		end
		cards = cards - 1
		return array[number], bust
	end
end

def gameloop(current_deck, user, cards)
	def view_deck(current_deck)
		count3 = 0
		while count3 < 52
			if array[count3][:dealt] == false
				puts current_deck[count3][:card] + ' of ' + current_deck[count3][:suit]
			else
			end
			count3 += 1
		end
	end

	current_deck = current_deck.sort_by{rand}

	if cards == 52
		puts 'd - Deal hand'
		puts 'q - Quit'
		print 'What would you like to do? '
	else 
		puts 'd - Draw another card'
		puts 'v - View hand'
		puts 's - Stand'
		puts 'q - Quit'
		print 'What would you like to do? '
	end

	input = gets.chomp
	input = input[0].downcase

	if input == 'd' && cards == 52
		#print_with_stars()
		puts 'Your were dealt: '
		user.push(draw(current_deck, cards))
		value = handcount(current_deck)
		puts "Your cards add up to #{value} points!"
		cards = 50
		#format
		puts '-------'
		gameloop(current_deck, user, cards)
	elsif input == 'd' && cards != 52
		#print_with_stars()
		count4 = handcount(current_deck)
		ha, bool = drawone(current_deck, cards, count4)
		user.push(ha)
		#user.push(drawone(array, cards, count4))
		cards = cards - 1
		#format
		puts '-------'
		if bool == true
			user = []
			cards = 52
			gameloop(create_deck_of_cards_array, user, cards)
		else
			gameloop(current_deck, user, cards)
		end
	elsif input == 'v' && cards != 52
		string = "You have #{52-cards} cards in your hand! " + "\n" + "Your hand includes the following:" + "\n"
		count4, string2 = viewhand(current_deck, string)
		string = string2 + "Your cards add up to #{count4} points!" + "\n"
		print_with_stars(string)
		puts '-------'
		gameloop(current_deck, user, cards)
	elsif input == 's' && cards != 52
		string = "You have #{52-cards} cards in your hand! " + "\n" + "Your hand includes the following:" + "\n"
		count4, string = viewhand(current_deck, string)
		string += dealer(count4)
		print_with_stars(string)
		user = []
		cards = 52
		gameloop(create_deck_of_cards_array, user, cards)
	elsif input == 'q'
		puts 'Goodbye!'
		exit
	else
		puts 'Please enter a valid input!'
		gameloop(current_deck, user, cards)
	end
end

cards = 52
gameloop(create_deck_of_cards_array, [], cards)
