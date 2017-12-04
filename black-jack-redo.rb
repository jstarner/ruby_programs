def array_gen
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

def get_suit(string)
	card_suit = ''
	if string[0] == 'S'
		card_suit = "Spades\n"
	elsif string[0] == 'H'
		card_suit = "Hearts\n"
	elsif string[0] == 'D'
		card_suit = "Diamonds\n"
	elsif string[0] == 'C'
		card_suit = "Clubs\n"
	else 
		puts 'Something went wrong!'
	end

	return card_suit
end

def get_card(card)
	user_card = ''
	if card[1] == 'A'
		user_card = 'Ace of ' + get_suit(card)
	elsif card[1] == 'J'
		user_card = 'Jack of ' + get_suit(card)
	elsif card[1] == 'Q'
		user_card = 'Queen of ' + get_suit(card)
	elsif card[1] == 'K'
		user_card =  'King of ' + get_suit(card)
	elsif (card[1].to_i >= 2) || (card[1..-1].to_i <= 10)
		user_card = "#{card[1..-1]} of " + get_suit(card)
	else
		puts 'Something went wrong when retrieving the card!'
		return
	end
	return user_card
end

def viewhand(array, is_user)
	count = 0
	hand_value = 0
	if is_user == 'true'
		user_hand = "You have #{array.length} cards in your hand! " + "\n" + "Your hand includes the following:" + "\n"
	else
		user_hand = "The dealer has:" + "\n"
	end

	while count < array.length
		string = array[count]
		if string[1] == 'A'
			user_hand = user_hand + 'Ace of ' + get_suit(array[count])
			hand_value += 11
			count += 1
		elsif string[1] == 'J'
			user_hand = user_hand + 'Jack of ' + get_suit(array[count])
			hand_value += 10
			count += 1
		elsif string[1] == 'Q'
			user_hand = user_hand + 'Queen of ' + get_suit(array[count])
			hand_value += 10
			count += 1
		elsif string[1] == 'K'
			user_hand = user_hand + 'King of ' + get_suit(array[count])
			hand_value += 10
			count += 1
		elsif (string[1].to_i >= 2) || (string[1..-1].to_i <= 10)
			user_hand = user_hand + "#{string[1..-1]} of " + get_suit(array[count])
			hand_value += string[1..-1].to_i
			count += 1
		else
			puts 'Something went wrong!'
			return
		end
	end

	if is_user == 'true'
		user_hand = user_hand + "Your cards add up to #{hand_value} points!" + "\n"
	else
		user_hand = user_hand + "The dealers cards add up to #{hand_value} points!" + "\n"
	end
	return user_hand, hand_value
end

def who_wins(array, current_hand, dealer_hand)
	string = ''
	user_hand, hand_value = viewhand(current_hand, 'true')
	updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'false')
	if (dealer_value < 17) && (dealer_value < hand_value)
		updated__dealer_hand = ''
		updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'false')
		print_with_stars(updated_dealer_hand)
		while (dealer_value < 17) && (dealer_value < hand_value)
			#drawn_card = array.pop
			#dealer_hand.push(drawn_card)
			#string_append, updated_hand_value = viewhand(dealer_hand, 'false')
			#dealer_value = updated_hand_value
			updated_dealer_hand, bool = drawone(array, dealer_hand)
			array.pop
			updated_dealer_hand, dealer_value = viewhand(dealer_hand, 'false')
			if bool == true
				string = string + 'The dealer bust! You win!'
				print_with_stars(string)
				return
			else
			end
		end

		string = user_hand + updated_dealer_hand
		if hand_value == dealer_value
			string = string + "You and the dealer both had #{dealer_value}, it's a tie!"
		elsif hand_value < dealer_value
			string = string + "The dealer had #{dealer_value} and you had #{hand_value}, you lose!"
		else hand_value > dealer_value
			string = string + "The dealer had #{dealer_value} and you had #{hand_value}, you win!"
		end
	else
		string = user_hand + updated_dealer_hand
		if hand_value == dealer_value
			string = string + "You and the dealer both had #{dealer_value}, it's a tie!"
		elsif hand_value < dealer_value
			string = string + "The dealer had #{dealer_value} and you had #{hand_value}, you lose!"
		else hand_value > dealer_value
			string = string + "The dealer had #{dealer_value} and you had #{hand_value}, you win!"
		end
	end

	print_with_stars(string)
end

def drawone(array, current_hand)
	bust = false
	drawn_card = array.pop
	current_hand.push(drawn_card)
	string_append, hand_value = viewhand(current_hand, 'true')
	string = ''
	string = string + string_append
	if hand_value > 21
		bust = true
	end
	return string, bust
end

def gameloop(array, user, dealer)
	if array.length == 52
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

	if input == 'd' && array.length == 52
		user.push(array.pop)
		user.push(array.pop)
		dealer.push(array.pop)
		dealer.push(array.pop)
		string = ''
		string_append, hand_value = viewhand(user, 'true')
		string = string + string_append + 'The dealer has a ' + get_card(dealer[0])
		print_with_stars(string)
		gameloop(array, user, dealer)
	elsif input == 'd' && array.length != 52
		drawn_card = array.pop
		string = 'Your were dealt: ' + get_card(drawn_card) + ' of ' + get_suit(drawn_card)
		updated_hand, bool = drawone(array, user)
		string = string + updated_hand

		if bool == true
			print_with_stars(string + "Oh no! Your total is now #{hand_value} which is greater than 21, you lose!")
			user = []
			dealer = []
			gameloop(array_gen, user, dealer)
		else
			print_with_stars(string)
			gameloop(array, user, dealer)
		end
	elsif input == 'v' && array.length != 52
		string, hand_value = viewhand(user, 'true')
		print_with_stars(string)
		gameloop(array, user, dealer)
	elsif input == 's' && array.length != 52
		who_wins(array, user, dealer)
		user = []
		dealer = []
		gameloop(array_gen, user, dealer)
	elsif input == 'q'
		puts 'Goodbye!'
		exit
	else
		puts 'Please enter a valid input!'
		gameloop(array, user, dealer)
	end
end

user = []
dealer = []
print_with_stars('Welcome to the Casino!')
gameloop(array_gen, user, dealer)
