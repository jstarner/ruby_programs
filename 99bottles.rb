line_3 = "Take one down, pass it around"

puts '99 bottles of beer on the wall'
puts '99 bottles of beer'
puts line_3

97.times do |i|
	quantity = 98 - i

	puts "#{quantity} bottles of beer on the wall"
	puts "#{quantity} bottles of beer on the wall"
	puts "#{quantity} bottles of beer"
	puts line_3
end

puts '1 bottle of beer on the wall'
puts '1 bottle of beer on the wall'
puts '1 bottle of beer'
puts line_3
puts 'No more bottles of beer on the wall'
