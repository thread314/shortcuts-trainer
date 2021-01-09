#Read file and set variables
require 'date'
shortcuts = File.read("cards").split("\n").shuffle
timestart = Time.now
correct = 0

#Quit and save 
def quitdrilling
	quitanswer = ""
	until quitanswer == "y" || quitanswer == "n"
		puts "Finished for today. Would you like to save today's session to file? (y/n)"
		quitanswer = gets.chomp
		case quitanswer
		when "y"
			puts "Goodbye"
			writetofile = ($dueshortcuts+$notdueshortcuts).join("\n")
			File.open("cards", 'w') { |file| file.write(writetofile) }
		when "n"
			puts "This session will not be saved to file. Goodbye"
		end
	end
end

#Mark a correct answer
def markcorrect(answer)
	if !answer[2]
		answer.push(Date.today)
		answer.push(1)
	else
		answer[2] = Date.today + answer[3].to_i
		answer[3] = answer[3].to_i * 2
	end
	return answer.join("||")
end

#Mark an incorrect answer
def markincorrect(answer)
	puts "#{answer[0]}||#{answer[1]}"
	return "#{answer[0]}||#{answer[1]}"
end

#Remove a shortcut from future testing
def removeshortcut(answer)
	puts "# #{answer[0]}||#{answer[1]}"
	return "# #{answer[0]}||#{answer[1]}"
end

#Filter for all cards that are not due
$dueshortcuts = []
$notdueshortcuts = []
shortcuts.each do |i|
	current = i.split("||")
	if current[0].to_s[0] == "#"
		$notdueshortcuts.push(i)
	elsif !current[2] || DateTime.parse(current[2]).to_date <= Date.today 
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
		break
	elsif useranswer == "remove"
		puts "that shortcut has been commented out"
		removeshortcut(current)
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

quitdrilling
puts "All finished"
puts "It took #{(Time.now - timestart).to_i} seconds."
if total != 0
	puts "#{(correct*100/total)}% correct"
end

