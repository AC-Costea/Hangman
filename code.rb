
words = File.read("google-10000-english-no-swears.txt").split
guess_word = words[rand(1..9893)].split('')
until guess_word.length >= 5 && guess_word.length <= 12
    guess_word = words[rand(1..9893)].split('')
end
hidden_word = []
guess_word.length.times do
    hidden_word.push('_')
end

puts guess_word.join('')
puts hidden_word.join('')

mistakes = 0

until mistakes == 6 || hidden_word.include?('_') == false
    input_letter = gets.chomp.downcase
    if input_letter != '' && guess_word.include?(input_letter)
        guess_word.each_with_index do |letter, index|
            if input_letter == letter
                hidden_word[index] = input_letter
                guess_word[index] = ''
                break
            end
        end
    else
        mistakes +=1
    end
    print "\r" + ("\e[A\e[K"*1)
    puts hidden_word.join('')
end
