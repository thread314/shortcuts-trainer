#Read file and set variables
require 'date'
shortcuts = File.read("cards").split("\n").shuffle
timestart = Time.now
correct = 0

# Save today's progress and close the app
def close
	puts "Goodbye"
	writetofile = ($dueshortcuts+$notdueshortcuts).join("\n")
	File.open("cards", 'w') { |file| file.write(writetofile) }
end

#Update a correct answer
def markcorrect(answer)
	if !answer[2]
		answer.push(Date.today)
		answer.push(1)
	else
		answer[2] = Date.today + answer[3]
		answer[3] = answer[3] * 2
	end
	return answer.join("||")
end

#Update an incorrect answer
def markincorrect(answer)
	return "#{answer[0]}||#{answer[1]}"
end

#Filter for all cards that are not due
$dueshortcuts = []
$notdueshortcuts = []
shortcuts.each do |i|
	current = i.split("||")
	if !current[2] || DateTime.parse(current[2]).to_date <= Date.today
		$dueshortcuts.push(i)
	else
		$notdueshortcuts.push(i)
	end
end

#Start drilling today's cards
remaining = $dueshortcuts.count
total = remaining
$dueshortcuts.map! do |item|
	current = item.split("||")
	question = current[0]
	answer = current[1]
	puts "#{question} - (#{remaining} cards remaining)"
	useranswer = gets.chomp
	remaining -= 1
	if useranswer == "exit"
		puts "user ended"
		close
		break
	elsif answer == useranswer
		puts "#{(correct*100/total)}% correct"
		puts "\e[32mCorrect!\e[0m"
		correct += 1
		markcorrect(current)
	else
		puts "\e[31mWrong\e[0m"
		puts answer
		markincorrect(current)
	end
end
puts $notdueshortcuts.class
puts "All finished"
puts "It took #{(Time.now - timestart).to_i} seconds."
puts "#{(correct*100/total)}% correct"
close
