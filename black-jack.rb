puts 'Welcome to the Casino!'

def array_gen(array)
	suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
	cards = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King']
	value = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
	array = []
	count = 0
	count2 = 0
	count3 = 0

	while count < 4
		while count2 < 13
		hash = { suit: suits[count], card: cards[count2], dealt: false, value: value[count2]}
		array.push(hash)
		count2 += 1
		count3 += 1
		end
		count += 1
		count2 = 0
	end
	return array
end

def print_with_stars(string)
	puts '*' * 60
	puts '*' * 60
	puts string
	puts '*' * 60
	puts '*' * 60
end

def viewhand(array, string)
	count3 = 0
	count4 = 0
	while count3 < array.length
		if array[count3][:dealt] == true
			string += array[count3][:card] + ' of ' + array[count3][:suit] + "\n"
			count4 += array[count3][:value]
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

def draw(array, cards)
	number = rand(52)
	if cards == 50
		return array[number]
	elsif array[number][:dealt] == true
		draw(array, cards)
	else
		array[number][:dealt] = true
		puts array[number][:card] + ' of ' + array[number][:suit]
		cards = cards - 1
		draw(array, cards)
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

	array = array.sort_by{rand}

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
	input.downcase!

	if input == 'd' && cards == 52
		#print_with_stars()
		puts 'Your were dealt: '
		user.push(draw(array, cards))
		value = handcount(array)
		puts "Your cards add up to #{value} points!"
		cards = 50
		#format
		puts '-------'
		gameloop(array, user, cards)
	elsif input == 'd' && cards != 52
		#print_with_stars()
		count4 = handcount(array)
		ha, bool = drawone(array, cards, count4)
		user.push(ha)
		#user.push(drawone(array, cards, count4))
		cards = cards - 1
		#format
		puts '-------'
		if bool == true
			array = []
			user = []
			cards = 52
			array = array_gen(array)
			gameloop(array, user, cards)
		else
			gameloop(array, user, cards)
		end
	elsif input == 'v' && cards != 52
		string = "You have #{52-cards} cards in your hand! " + "\n" + "Your hand includes the following:" + "\n"
		count4, string2 = viewhand(array, string)
		string = string2 + "Your cards add up to #{count4} points!" + "\n"
		print_with_stars(string)
		puts '-------'
		gameloop(array, user, cards)
	elsif input == 's' && cards != 52
		string = "You have #{52-cards} cards in your hand! " + "\n" + "Your hand includes the following:" + "\n"
		count4, string = viewhand(array, string)
		string += dealer(count4)
		print_with_stars(string)
		array = []
		user = []
		cards = 52
		array = array_gen(array)
		gameloop(array, user, cards)
	elsif input == 'q'
		puts 'Goodbye!'
		exit
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
