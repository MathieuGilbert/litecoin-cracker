git clone https://github.com/MathieuGilbert/cracker.git
cd cracker
git clone https://github.com/litecoin-project/litecoin.git
./litecoin/src/litecoind
*new tab*
cp wallet.dat litecoin/
cd litecoin/src
irb
require '../crack.rb'
Crack.new(['seven', 'eight', 'nine']).run
