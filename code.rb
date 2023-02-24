require 'json'

class Hangman
    def word_forming
        words = File.read('google-10000-english-no-swears.txt').split
        @intact_guess_word = words[rand(1..9893)]
        until @intact_guess_word.length >= 5 && @intact_guess_word.length <= 12
            @intact_guess_word = words[rand(1..9893)]
        end
        @guess_word = @intact_guess_word.split('')
        @hidden_word = []
        @guess_word.length.times do
            @hidden_word.push('_')
        end
        @mistakes = 0
    end
    
    def save_data
        data = {
            intact_guess_word: @intact_guess_word,
            hidden_word: @hidden_word,
            guess_word: @guess_word,
            mistakes: @mistakes
        }
        File.open('data.json', 'w') do |file|
            JSON.dump(data, file)
        end
    end

    def use_save_data
        json_data = File.read('/mnt/c/Users/const/downloads/repos/Hangman/data.json')
        save_data = JSON.parse(json_data)
        @intact_guess_word = save_data['intact_guess_word']
        @hidden_word = save_data['hidden_word']
        @guess_word = save_data['guess_word']
        @mistakes = save_data['mistakes']
    end
    
    def play
        if File.exist?('/mnt/c/Users/const/downloads/repos/Hangman/data.json')
            puts "If you want to load previous save data, write '1', else write '0'"
            input = gets.chomp
            print "\r" + ("\e[A\e[K"*1)
            until input == '1' || input == '0'
                puts 'Write either 1 or 0'
                input = gets.chomp
                print "\r" + ("\e[A\e[K"*2)
            end
            print "\r" + ("\e[A\e[K"*1)
            self.use_save_data if input == '1'
        end

        puts 'Introduce a letter until you complete the word, you are allowed only 6 mistakes'
        puts "If you want to save, write 'save' " 
        puts "---------------------------------------------------------------------------------------------- \n\n"
        puts "      Mistakes: #{@mistakes}\n\n"
        puts "      #{@hidden_word.join('')}\n\n"
        puts '----------------------------------------------------------------------------------------------'

        alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

        until @mistakes == 6 || @hidden_word.include?('_') == false
            input_letter = gets.chomp.downcase
            until alphabet.include?(input_letter) || input_letter == 'save'
                puts 'Introduce a letter!'
                input_letter = gets.chomp.downcase
                print "\r" + ("\e[A\e[K"*2)
            end
            if @guess_word.include?(input_letter)
                @guess_word.each_with_index do |letter, index|
                    if input_letter == letter
                        @hidden_word[index] = input_letter
                        @guess_word[index] = ''
                        break
                    end
                end
            elsif input_letter == 'save'
                self.save_data
            else
                @mistakes +=1
            end
            print "\r" + ("\e[A\e[K"*6)
            puts "      Mistakes: #{@mistakes}\n\n"
            puts "      #{@hidden_word.join('')}\n\n"
            puts '----------------------------------------------------------------------------------------------'
        end
        puts ''
        puts "Guess word: '#{@intact_guess_word}'"
    end
end

new_game = Hangman.new
new_game.word_forming
new_game.play