#Rules of the game can be viewed at this webstie https://www.pagat.com/banking/blackjack.html

def generate_deck_of_cards
	suits = ['S', 'H', 'D', 'C']
	cards = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '1', 'J', 'Q', 'K']
	array = []
	count = 0
	count2 = 0

	while count < 4
		while count2 < 13
			string = suits[count] + cards[count2]
			array.push(string)
			count2 += 1
		end
		count += 1
		count2 = 0
	end

	array = array.sort_by{rand}
	return array
end

def print_with_stars(string)
	puts '*' * 60
	puts '*' * 60
	puts string
	puts '*' * 60
	puts '*' * 60
	puts '--------'
end

def player_views_hand(current_hand)
	string, hand_value = viewhand(current_hand, 'true')
	print_with_stars(string)
end

def player_stands(current_deck, player_hand, dealer_hand)
	who_wins(current_deck, player_hand, dealer_hand)
end

def get_suit(card)
	suit = card[0]
	case suit
	when 'S'
		card_suit = "Spades\n"
	when 'H'
		card_suit = "Hearts\n"
	when 'D'
		card_suit = "Diamonds\n"
	when 'C'
		card_suit = "Clubs\n"
	else 
		puts 'Something went wrong!'
	end

	return card_suit
end

def get_card(card)
	cards = card[1..-1]
	case cards
	when 'A'
		user_card = 'Ace of '
	when 'a'
		user_card = 'Ace of '
	when 'J'
		user_card = 'Jack of '
	when 'Q'
		user_card = 'Queen of '
	when 'K'
		user_card =  'King of '
	else
		user_card = "#{card[1..-1]} of "
	end

	user_card = user_card + get_suit(card)
	return user_card
end

def viewhand(current_hand_array, is_player)
	hand_value = 0
	if is_player == 'true'
		user_hand = "You have #{current_hand_array.length} cards in your hand! " + "\n" + "Your hand includes the following:" + "\n"
	else
		user_hand = "The dealer has:" + "\n"
	end

	current_hand_array.length.times do |array_index|
		current_card = current_hand_array[array_index][1..-1]
		case current_card
		when 'A'
			user_hand = user_hand + 'Ace of '
			hand_value += 11
		when 'a'
			user_hand = user_hand + 'Ace of '
			hand_value += 1
		when 'J'
			user_hand = user_hand + 'Jack of '
			hand_value += 10
		when 'Q'
			user_hand = user_hand + 'Queen of '
			hand_value += 10
		when 'K'
			user_hand = user_hand + 'King of '
			hand_value += 10
		else
			user_hand = user_hand + "#{current_card} of "
			hand_value += current_card.to_i
		end

		user_hand = user_hand + get_suit(current_hand_array[array_index])
	end

	if is_player == 'true'
		user_hand = user_hand + "Your cards add up to #{hand_value} points!" + "\n"
	else
		user_hand = user_hand + "The dealers cards add up to #{hand_value} points!" + "\n"
	end
	return user_hand, hand_value
end

def get_value_of_hand(current_hand)
	user_hand, hand_value = viewhand(current_hand, 'true')
	return hand_value
end

def compare_player_dealer_points(player_points, dealer_points)
	if player_points == dealer_points
		winner = "You and the dealer both had #{dealer_points}, dealer wins!"
	elsif player_points < dealer_points
		winner = "The dealer had #{dealer_points} and you had #{player_points}, you lose!"
	elsif player_points > dealer_points
		winner = "The dealer had #{dealer_points} and you had #{player_points}, you win!"
	else
		puts "Something went wrong when determining who won!!"
	end

	return winner
end

def who_wins(current_deck, current_hand, dealer_hand)
	user_hand, hand_value = viewhand(current_hand, 'true')
	updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'false')
	if (dealer_value < 17) && (dealer_value < hand_value)
		updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'false')
		print_with_stars(updated_dealer_hand)
		while (dealer_value < 17) && (dealer_value < hand_value)
			updated_dealer_hand, bool = drawone_card(current_deck, dealer_hand)
			current_deck.pop
			updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'false')
			print_with_stars(updated_dealer_hand)
			if bool == true
				who_wins_string = 'The dealer bust! You win!'
				print_with_stars(who_wins_string)
				return
			end
		end

		who_wins_string = user_hand + updated_dealer_hand + compare_player_dealer_points(hand_value, dealer_value)
	else
		who_wins_string = user_hand + updated_dealer_hand + compare_player_dealer_points(hand_value, dealer_value)
	end

	print_with_stars(who_wins_string)
end

def hand_contains_ace(current_hand)
	if (current_hand.include?('SA')) || (current_hand.include?('HA')) || (current_hand.include?('DA') )|| (current_hand.include?('CA'))
		return true
	else
		return false
	end
end

def ace_handler(current_hand)
	current_hand.length.times do |array_index|
		if current_hand[array_index].include?('SA') || current_hand[array_index].include?('HA') || current_hand[array_index].include?('DA') || current_hand[array_index].include?('CA')
			current_hand[array_index] = current_hand[array_index][0] + current_hand[array_index][1].downcase
		else
		end
	end
end

def drawone_card(array, current_hand)
	bust = false
	drawn_card = array.pop
	if (drawn_card[1] == 'A') && (current_hand.length >= 1)
		current_hand.push(drawn_card)
		if get_value_of_hand(current_hand) > 21
			if hand_contains_ace(current_hand)
				ace_handler(current_hand)
				current_hand_as_string, hand_value = viewhand(current_hand, 'true')
				if hand_value > 21
					bust = true
				end
			else
				card = current_hand.pop
				small_value_ace = card[0] + 'a'
				current_hand.push(small_value_ace)
				current_hand_as_string, hand_value = viewhand(current_hand, 'true')
				if hand_value > 21
					bust = true
				end
			end
		else
			current_hand_as_string, hand_value = viewhand(current_hand, 'true')
			if hand_value > 21
				bust = true
			end
		end
	else
		current_hand.push(drawn_card)
		if get_value_of_hand(current_hand) > 21
			if hand_contains_ace(current_hand)
				ace_handler(current_hand)
				current_hand_as_string, hand_value = viewhand(current_hand, 'true')
				if hand_value > 21
					bust = true
				end
			else
				current_hand_as_string, hand_value = viewhand(current_hand, 'true')
				if hand_value > 21
					bust = true
				end
			end
		else
			current_hand_as_string, hand_value = viewhand(current_hand, 'true')	
		end
	end
	return current_hand_as_string, bust
end

def gameloop(current_deck, user, dealer)
	if current_deck.length == 52
		puts  'd - Deal hand'
		puts  'q - Quit'
		print 'What would you like to do? '
	else 
		puts  'd - Draw another card'
		puts  'v - View hand'
		puts  's - Stand'
		puts  'q - Quit'
		print 'What would you like to do? '
	end

	input = gets.chomp
	input.downcase!      

	if input == 'd' && current_deck.length == 52
		user_hand, bool = drawone_card(current_deck, user)
		user_hand, bool = drawone_card(current_deck, user)
		dealer_hand, bool = drawone_card(current_deck, dealer)
		dealer_hand, bool = drawone_card(current_deck, dealer)
		hand_as_string, hand_value = viewhand(user, 'true')
		output_string = hand_as_string + 'The dealer has a ' + get_card(dealer[0])
		print_with_stars(output_string)
		gameloop(current_deck, user, dealer)
	elsif input == 'd' && current_deck.length != 52
		drawn_card = current_deck[current_deck.length-1]
		updated_hand, bool = drawone_card(current_deck, user)
		output_string = 'Your were dealt: ' + get_card(drawn_card)
		output_string = output_string + updated_hand

		if bool == true
			print_with_stars(output_string + "Oh no! Your total is now #{get_value_of_hand(user)} which is greater than 21, you lose!")
			user = []
			dealer = []
			gameloop(generate_deck_of_cards, user, dealer)
		else
			print_with_stars(output_string)
			gameloop(current_deck, user, dealer)
		end
	elsif input == 'v' && current_deck.length != 52
		player_views_hand(user)
		gameloop(current_deck, user, dealer)
	elsif input == 's' && current_deck.length != 52
		player_stands(current_deck, user, dealer)
		user = []
		dealer = []
		gameloop(generate_deck_of_cards, user, dealer)
	elsif input == 'q'
		puts 'Goodbye!'
		exit
	else
		puts 'Please enter a valid input!'
		gameloop(current_deck, user, dealer)
	end
end

user = []
dealer = []
print_with_stars('Welcome to the Casino!')
gameloop(generate_deck_of_cards, user, dealer)
