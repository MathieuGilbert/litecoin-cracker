load '~/src/cracker/word.rb'

class Crack
  attr_accessor :passphrase, :password_list, :found, :start_time

  def initialize(passphrase = nil)
    # words in this order
    self.passphrase = passphrase || ['one', 'two', 'three']
  end

  def generate_password_list_file
    fill_password_list

    File.open("passwords-#{ self.passphrase.join }.txt", 'w') do |file|
      self.password_list.each do |password|
        file.puts(password)
      end
    end
    nil
  end

  def run
    fill_password_list

    start self.password_list
  end

  def run_from_file(file_name)
    password_list = []
    File.open(file_name) { |f| password_list = f.to_a.map(&:strip) }

    start password_list
  end

  private

  def start(password_list)
    self.found = false
    self.start_time = Time.now

    attempt_all password_list
  end

  def fill_password_list
    self.password_list = cartesian_product(word_options).map(&:join)
  end

  def word_options
    self.passphrase.map { |world| Word.new(world).explode }
  end

  def cartesian_product(array)
    array.inject(&:product).map(&:flatten)
  end

  def attempt_all(phrases)
    phrases.each_with_index do |phrase, index|
      return if self.found
      attempt(phrase, index + 1)
    end

    puts "\nNot found :(\n"
  end

  def attempt(phrase, count)
    update_progress(phrase, count)

    system("./litecoin-cli", "walletpassphrase", phrase, "1", err: File::NULL)

    case $?.exitstatus
    when 0
      put_alert " CRACKED! "
      puts "#{phrase}"
      put_alert " CRACKED! "
      self.found = true
      return
    when 127
      puts "litecoin-cli not found in current dir"
    end
  end

  def elapsed_seconds
    Time.now - self.start_time
  end

  def update_progress(phrase, count)
    attempt = "#{count.to_s.rjust(10)}"
    passphrase = "#{phrase.ljust(30)}"
    rate = "#{(count / elapsed_seconds).round(1)} /s"
    elapsed = "#{elapsed_seconds}"

    print "#{duration} - #{attempt} - #{passphrase} - #{rate}"
    print "\r"
  end

  def put_alert(text)
    pads = 20
    puts text.ljust(pads + text.length, '~').rjust(2 * pads + text.length, '~')
  end

  def duration
    total_seconds = elapsed_seconds

    h = total_seconds / 3600
    total_seconds -= h * 3600
    m = total_seconds / 60
    total_seconds -= m * 60
    s = total_seconds

    [h, m, s].map do |part|
      part.round.to_s.rjust(2, '0')
    end.join ':'
  end
end
