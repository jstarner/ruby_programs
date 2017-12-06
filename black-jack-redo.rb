#Rules of the game can be viewed at this webstie https://www.pagat.com/banking/blackjack.html
#Author of program: Justin Starner

def generate_deck_of_cards
	suits = ['S', 'H', 'D', 'C']
	cards = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '1', 'J', 'Q', 'K']
	deck_of_cards = []

	suits.length.times do |suit|
		cards.length.times do |card|
			card_as_string = suits[suit] + cards[card]
			deck_of_cards.push(card_as_string)
		end
	end

	deck_of_cards = deck_of_cards.sort_by{rand}
	return deck_of_cards
end

def print_with_stars(output_string)
	puts '*' * 60
	puts '*' * 60
	puts output_string
	puts '*' * 60
	puts '*' * 60
	puts '--------'
end

def player_views_hand(current_hand)
	string, hand_value = viewhand(current_hand, 'player')
	print_with_stars(string)
end

def player_stands(current_deck, player_hand, dealer_hand)
	print_game_results(current_deck, player_hand, dealer_hand)
end

def get_suit(card)
	suit = card[0]
	case suit
	when 'S'; card_suit = "Spades\n"
	when 'H'; card_suit = "Hearts\n"
	when 'D'; card_suit = "Diamonds\n"
	when 'C'; card_suit = "Clubs\n"
	else    ; puts 'Something went wrong!'
	end

	return card_suit
end

def get_card(card)
	cards = card[1..-1]
	case cards
	when 'A'; user_card = 'Ace of '
	when 'a'; user_card = 'Ace of '
	when 'J'; user_card = 'Jack of '
	when 'Q'; user_card = 'Queen of '
	when 'K'; user_card = 'King of '
	else    ; user_card = "#{card[1..-1]} of "
	end

	user_card = user_card + get_suit(card)
	return user_card
end

def viewhand(current_hand_array, player)
	hand_value = 0
	if player == 'player'
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

	if player == 'player'
		user_hand = user_hand + "Your cards add up to #{hand_value} points!" + "\n"
	else
		user_hand = user_hand + "The dealers cards add up to #{hand_value} points!" + "\n"
	end
	return user_hand, hand_value
end

def get_value_of_hand(current_hand)
	user_hand, hand_value = viewhand(current_hand, 'player')
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

def print_game_results(current_deck, current_hand, dealer_hand)
	dealer_stand_minimum_points = 17
	user_hand, player_hand_value = viewhand(current_hand, 'player')
	updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'dealer')
	if (dealer_value < dealer_stand_minimum_points) && (dealer_value < player_hand_value)
		updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'dealer')
		print_with_stars(updated_dealer_hand)
		while (dealer_value < dealer_stand_minimum_points) && (dealer_value < player_hand_value)
			updated_dealer_hand, bust = drawone_card(current_deck, dealer_hand)
			current_deck.pop
			updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'dealer')
			print_with_stars(updated_dealer_hand)
			if bust == true
				game_results_string = 'The dealer bust! You win!'
				print_with_stars(game_results_string)
				return
			end
		end
		game_results_string = user_hand + updated_dealer_hand + compare_player_dealer_points(player_hand_value, dealer_value)
	else
		game_results_string = user_hand + updated_dealer_hand + compare_player_dealer_points(player_hand_value, dealer_value)
	end

	print_with_stars(game_results_string)
end

def hand_contains_ace(current_hand)
	if current_hand.length > (current_hand - ['SA','HA','DA','CA']).length
		return true
	else
		return false
	end
end

def ace_handler(current_hand)
	current_hand.length.times do |i|
		if current_hand[i].include?('SA') || current_hand[i].include?('HA') || current_hand[i].include?('DA') || current_hand[i].include?('CA')
			current_hand[i] = current_hand[i][0] + current_hand[i][1].downcase
		else
		end
	end
end

def check_for_bust(current_hand)
	current_hand_as_string, hand_value = viewhand(current_hand, 'player')
	if hand_value > 21
		bust = true
	else
		bust = false
	end

	return current_hand_as_string, bust
end

def drawone_card(array, current_hand)
	bust = false
	drawn_card = array.pop
	if (drawn_card[1] == 'A') && (current_hand.length >= 1)
		current_hand.push(drawn_card)
		if get_value_of_hand(current_hand) > 21
			if hand_contains_ace(current_hand)
				ace_handler(current_hand)
				current_hand_as_string, bust = check_for_bust(current_hand)
			else
				card = current_hand.pop
				small_value_ace = card[0] + 'a'
				current_hand.push(small_value_ace)
				current_hand_as_string, bust = check_for_bust(current_hand)
			end
		else
			current_hand_as_string, bust = check_for_bust(current_hand)
		end
	else
		current_hand.push(drawn_card)
		if get_value_of_hand(current_hand) > 21
			if hand_contains_ace(current_hand)
				ace_handler(current_hand)
				current_hand_as_string, bust = check_for_bust(current_hand)
			else
				current_hand_as_string, bust = check_for_bust(current_hand)
			end
		else
			current_hand_as_string, hand_value = viewhand(current_hand, 'player')	
		end
	end
	return current_hand_as_string, bust
end

def gameloop(current_deck, player_hand, dealer_hand)
	full_deck_card_count = 52
	if current_deck.length == full_deck_card_count
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
	input = input[0]

	if input == 'd' && current_deck.length == full_deck_card_count
		player_hand_as_string, bust = drawone_card(current_deck, player_hand)
		player_hand_as_string, bust = drawone_card(current_deck, player_hand)
		dealer_hand_as_string, bust = drawone_card(current_deck, dealer_hand)
		dealer_hand_as_string, bust = drawone_card(current_deck, dealer_hand)
		hand_as_string, hand_value = viewhand(player_hand, 'player')
		output_string = hand_as_string + 'The dealer has a ' + get_card(dealer_hand[0])
		print_with_stars(output_string)
		gameloop(current_deck, player_hand, dealer_hand)
	elsif input == 'd' && current_deck.length != full_deck_card_count
		drawn_card = current_deck[current_deck.length-1]
		updated_hand, bust = drawone_card(current_deck, player_hand)
		output_string = 'Your were dealt: ' + get_card(drawn_card)
		output_string = output_string + updated_hand

		if bust == true
			print_with_stars(output_string + "Oh no! Your total is now #{get_value_of_hand(player_hand)} which is greater than 21, you lose!")
			player_hand = []
			dealer_hand = []
			gameloop(generate_deck_of_cards, player_hand, dealer_hand)
		else
			print_with_stars(output_string)
			gameloop(current_deck, player_hand, dealer_hand)
		end
	elsif input == 'v' && current_deck.length != full_deck_card_count
		player_views_hand(player_hand)
		gameloop(current_deck, player_hand, dealer_hand)
	elsif input == 's' && current_deck.length != full_deck_card_count
		player_stands(current_deck, player_hand, dealer_hand)
		player_hand = []
		dealer_hand = []
		gameloop(generate_deck_of_cards, player_hand, dealer_hand)
	elsif input == 'q'
		puts 'Goodbye!'
		exit
	else
		puts 'Please enter a valid input!'
		gameloop(current_deck, player_hand, dealer_hand)
	end
end

player_hand = []
dealer_hand = []
print_with_stars('Welcome to the Casino!')
gameloop(generate_deck_of_cards, player_hand, dealer_hand)
