class Word
  SUBS = {
    'a' => ['@'],
    'e' => ['3'],
    'g' => ['9'],
    'h' => ['#'],
    'i' => ['1', '!'],
    'l' => ['1', '!'],
    'o' => ['0'],
    'r' => ['2'],
    's' => ['$'],
    't' => ['7']
  }.freeze

  attr_accessor :word_array

  def initialize(the_word)
    self.word_array = arrayify_letters(the_word)
    expand_word
  end

  def explode
    split(word_array.first)
    self.word_array.map { |word| word.join '' }
  end

  private

  def expand_word
    add_case_options
    add_substitution_options
  end

  # For each word in word_array:
  # remove the word from word_array
  # pass word into function
  # function adds split words to word_array

  # word = [ ["c", "C"], ["a", "@"], ["k"], ["e", "E", "3"] ]
  def split(word, start_index = 0)
    return if word.flatten.length == word.length
    self.word_array.delete word

    word.each_with_index do |letters, index|
      next if index < start_index
      next if letters.length == 1

      letters.each do |letter|
        a = []
        i = 0
        while i < index do
          a << word[i]
          i += 1
        end

        b = []
        i = index + 1
        while i < word.length do
          b << word[i]
          i += 1
        end

        split_word = a + [[letter]] + b
        self.word_array << split_word

        split(split_word, index)
      end
    end
  end

  def arrayify_letters(word)
    [
      word.split('').map { |letter| [letter] }
    ]
  end

  def add_case_options
    self.word_array.first.first << self.word_array.first.first.first.upcase
    self.word_array.first.last << self.word_array.first.last.first.upcase
  end

  def add_substitution_options
    self.word_array.first.each do |letters|
      if values = SUBS[letters.first]
        values.each { |value| letters << value }
      end
    end
  end

end
