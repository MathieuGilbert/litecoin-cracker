class Dictionary
  attr_accessor :original

  def initialize
    File.open('extra_words.txt') do |password_list|
      self.original = password_list.to_a.map(&:strip)
    end
  end

  def my_words
    self.original
  end

end
