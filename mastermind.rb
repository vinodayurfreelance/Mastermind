# frozen_string_literal: true

class Mastermind
  def initialize
    @colors = %w[R G B Y]
    @secret = Array.new(4) { @colors.sample }
    @possible_codes = @colors.repeated_permutation(4).to_a
  end

  def show_intro
    puts 'Mastermind'
    puts 'Choose 4 colors using R, G, B, or Y.'
    puts
  end

  def get_guess
    puts 'Enter your guess:'
    gets.chomp.upcase.chars
  end

  def valid_guess?(guess)
    if guess.length != 4
      puts 'Please enter exactly 4 colors.'
      return false
    end

    guess.each do |color|
      unless @colors.include?(color)
        puts 'Please use only R, G, B, or Y.'
        return false
      end
    end

    true
  end

  def calculate_matches(secret, guess)
    exact_matches = 0
    wrong_position_matches = 0
    available = secret.dup

    # Pass 1: Find exact matches
    index = 0

    until index == 4
      if secret[index] == guess[index]
        exact_matches += 1
        available.delete_at(index)
      end

      index += 1
    end

    # Pass 2: Find wrong-position matches
    index = 0

    until index == 4
      if guess[index] != secret[index] &&
         available.include?(guess[index])
        wrong_position_matches += 1
        available.delete(guess[index])
      end

      index += 1
    end

    [exact_matches, wrong_position_matches]
  end

  def evaluate_guess(guess)
    calculate_matches(@secret, guess)
  end

  def eliminate_impossible_codes(guess, exact_matches, wrong_position_matches)
    @possible_codes.delete_if do |possible_code|
      matches = calculate_matches(possible_code, guess)
      matches != [exact_matches, wrong_position_matches]
    end
  end

  def possible_codes_count
    @possible_codes.length
  end

  def computer_guess
    @possible_codes.sample
  end

  def check_win(exact_matches)
    exact_matches == 4
  end

  def show_result(exact_matches, wrong_position_matches)
    puts "Exact matches: #{exact_matches}"
    puts "Wrong-position matches: #{wrong_position_matches}"
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Mastermind.new

  turns = 0

  until turns == 12
    computer_guess = game.computer_guess

    puts "Computer guess: #{computer_guess}"

    exact_matches, wrong_position_matches =
      game.evaluate_guess(computer_guess)

    game.eliminate_impossible_codes(
      computer_guess,
      exact_matches,
      wrong_position_matches
    )

    puts "Exact matches: #{exact_matches}"
    puts "Wrong-position matches: #{wrong_position_matches}"
    puts "Possible codes remaining: #{game.possible_codes_count}"
    puts

    turns += 1

    if game.check_win(exact_matches)
      puts 'Computer wins!'
      break
    end
  end
end
