load 'crack.rb'
load 'dictionary.rb'

class Multicrack
  attr_accessor :word_array

  def initialize(word_array = nil)
    self.word_array = word_array || defaults
  end

  def run
    possible_phrase_combos.each do |phrase|
      Crack.new(phrase).generate_password_list_file
    end
  end

  private

  def defaults
    [nil, 'seven', 'nine', 'eight']
  end

  def possible_phrase_combos
    needed = self.word_array.count(&:nil?)

    Dictionary.new.my_words.permutation(needed).map do |fillers|
      merged = self.word_array.dup
      fillers.count.times { |i| merged[i] = fillers[i] }
      merged
    end
  end

end
