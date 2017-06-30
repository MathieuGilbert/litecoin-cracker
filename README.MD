***Try it out***

You should be able to crack the included wallet file.

  cd <litecoin_path>
  git clone https://github.com/litecoin-project/litecoin.git

Build Litecoin core (https://github.com/litecoin-project/litecoin/blob/master/doc/build-osx.md)

  ./<litecoin_path>/litecoin/src/litecoind

New tab

  cd <code_path>
  git clone https://github.com/MathieuGilbert/litecoin-cracker.git
  cd litecoin-cracker
  ln -s <litecoin_path>/litecoin/src/litecoin-cli litecoin-cli

  irb

  > require './crack'
  > crack = Crack.new(['seven', 'eight', 'nine']).generate_password_list_file
  > crack.run_from_file('passwords-seveneightnine.txt')

  > require './multicrack'
  > Multicrack.new.run
  > Crack.new.run_from_file('passwords-foesevennineeight.txt')
