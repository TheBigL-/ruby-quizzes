# https://en.wikipedia.org/wiki/Solitaire_(cipher)
# 
# ENCYPTING MESSAGE
# 1. Discard any non A to Z characters, and uppercase all remaining letters.
#    Split the message into five character groups, using Xs to pad the last group, if needed. 
# 2. Use Solitaire to generate a keystream letter for each letter in the message.
# 3. Convert the message from step 1 into numbers, A = 1, B = 2, etc:
# 4. Convert the keystream letters from step 2 using the same method:
# 5. Add the message numbers from step 3 to the keystream numbers from step 4 and subtract 26 from the result if it is greater than 26.
# 6. Convert the numbers from step 5 back to letters:
# 

class Encryptor
    
    def initialize(keygen)
        @keygen = keygen
    end
    
    def scrunch(msg)
        msg.upcase!
        msg.gsub!(/[^A-Z]/,"")
        msg << "X" * ((5 - msg.length % 5) % 5)
    end
    
    def mod(num)
        num -= 26 if num > 26
        num += 26 if num < 1
        num
    end
    
    def process(msg, &cryptor)
        scrunched = scrunch(msg).chars.map {|char| (mod(cryptor.call(char)) + 64).chr}.join
        crypt = ""
        (scrunched.length / 5).times {|i| crypt << scrunched[i*5,5] << " "}
        crypt.chop
    end
    
    def encrypt(msg)
        process(msg) {|char| char.ord - 64 + @keygen.get_key}
    end
    
    def decrypt(msg)
        process(msg) {|char| char.ord - 64 - @keygen.get_key}
    end
    
end

# GENERATE KEYSTREAM
# 1. Key the decks by shuffling or using some secret indicator. (This script, however, will be using UNKEYED decks.)
# 2. Move Joker A one card down, then move Joker B two cards down. 
# 3. Perform triple cut around Jokers.
# 4. Perform count cut using bottom cards value.
# 5. Convert the top card to it's value and count down that many cards to find the first key
# 6. Repeat 2 - 5 for the rest of the keys
# 7. Output array of keys
# 

class Deck

    def initialize
        @deck = (1..52).to_a << "A" << "B"
    end
    
    def move_down(card)
        old_pos = @deck.index(card) 
        new_pos = old_pos > 52 ? old_pos - 52 : old_pos + 1
        @deck.insert(new_pos ,@deck.delete_at(old_pos))
    end
    
    def triple_cut
        top_J, bottom_J = [@deck.index("A"),@deck.index("B")].sort
        @deck.replace([@deck[(bottom_J+1)..-1],@deck[top_J..bottom_J],@deck[0...top_J]].flatten)
    end
    
    def count_cut
        @deck.insert(-2,*@deck.slice!(0..(@deck[-1]-1)))
    end
    
    def mod(num)
       num > 26 ? num -= 26 : num
    end
    
    def compose
        move_down("A")
        2.times {move_down("B")}
        triple_cut
        count_cut
    end
    
    def get_key
        compose
        pos = (@deck[0].is_a?(Fixnum) ? @deck[0] : 53)
        @deck[pos].is_a?(Fixnum) ? mod(@deck[pos]) : get_key
    end
    
end
