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



# GENERATE KEYSTREAM
# 1. Key the decks by shuffling or using some secret indicator. (This script, however, will be using UNKEYED decks.)
# 2. Move Joker A one card down, then move Joker B two cards down. 
# 3. Perform triple cut around Jokers.
# 4. Perform count cut using bottom cards value.
# 5. Convert the top card to it's value and count down that many cards to find the first key
# 6. Repeat 2 - 5 for the rest of the keys
# 7. Output array of keys

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
    def triple_cut # maybe use array#replace here?
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
        move_down("A")
        2.times {move_down("B")}
        triple_cut
        count_cut
        pos = (@deck[0].is_a?(Fixnum) ? @deck[0] : 53)
        @deck[pos].is_a?(Fixnum) ? @deck[pos] : get_key
    end
    
end
