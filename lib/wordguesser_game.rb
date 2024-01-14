class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_reader :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    validate_letter(letter)

    letter = letter.downcase
    update_guesses(letter) if correct_guess?(letter)
    update_wrong_guesses(letter) if incorrect_guess?(letter)
  end

  def word_with_guesses
    @word.chars.map { |char| @guesses.include?(char) ? char : '_' }.join
  end

  def check_game_status
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 7
    :play
  end

  private

  def validate_letter(letter)
    raise ArgumentError if letter.nil? || letter !~ /\A[a-zA-Z]\Z/i
  end

  def correct_guess?(letter)
    @word.include?(letter) && !@guesses.include?(letter)
  end

  def update_guesses(letter)
    @guesses += letter
  end

  def incorrect_guess?(letter)
    !@word.include?(letter) && !@wrong_guesses.include?(letter)
  end

  def update_wrong_guesses(letter)
    @wrong_guesses += letter
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
