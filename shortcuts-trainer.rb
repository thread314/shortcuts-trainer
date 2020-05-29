file_data = File.read("cards").split("\n").shuffle
timestart = Time.now
remaining = file_data.count
correct = 0
total = remaining
file_data.each do |current|
	question = current.gsub(/\{.+\}/,"")
	answer = current[/\{.+\}/][1..-2]
	puts "#{question} - (#{remaining} cards remaining)"
	useranswer = gets.chomp
	if answer == useranswer
		puts "#{(correct*100/total)}% correct"
		puts "\e[32mCorrect!\e[0m"
		correct += 1
	else
		puts "\e[31mWrong\e[0m"
		puts answer
	end
	remaining -= 1
end
puts "all finished"
puts "It took #{(Time.now - timestart).to_i} seconds."
puts "#{(correct*100/total)}% correct"
