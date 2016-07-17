# https://en.wikipedia.org/wiki/Solitaire_(cipher)
# 
# GENERATE KEYSTREAM
# 1. Key the decks by shuffling or using some secret indicator. (This script, however, will be using UNKEYED decks.)
# 2. Move Joker A one card down, move Joker B two cards down. 
# 3. Perform triple cut around Jokers.
# 4. Perform count cut using bottom cards value.
# 5. Convert the top card to it's value and count down that many cards to find the first key
# 6. Repeat 2 - 5 for the rest of the keys

class Deck

    def initialize
        @deck = (1..52).to_a << "A" << "B"
    end
    
    # move the Jokers down (step 2)
    def move_down(joker)
        old_pos = @deck.index(joker) 
        new_pos = old_pos > 52 ? old_pos - 52 : old_pos + 1
        @deck.insert(new_pos ,@deck.delete_at(old_pos))
    end
    
    # perfrom triple cut (step 3)
    def triple_cut 
        bottom_J = [@deck.index("A"),@deck.index("B")].max + 1
        bottom_slice = bottom_J > 53 ? nil : @deck.slice!(bottom_J..-1)
        top_J = [@deck.index("A"),@deck.index("B")].min - 1
        @deck += @deck.slice!(0..top_J) unless top_J < 0
        @deck.insert(0,*bottom_slice)
    end
    
    def count_cut
        @deck.insert(-2,*@deck.slice!(0..(@deck[-1]-1)))
    end
    
    def get_key
        pos = (@deck[0].is_a?(Fixnum) ? @deck[0] : 53)
        @deck[pos]
    end
    
end

def solitaire_keystream(length)
    keystream = []
    deck = Deck.new
    until keystream.length == length.to_i do
        deck.move_down("A")
        2.times {deck.move_down("B")}
        deck.triple_cut
        deck.count_cut
        keystream << deck.get_key if deck.get_key.is_a?(Fixnum)
    end
    keystream
end
