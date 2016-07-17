# https://en.wikipedia.org/wiki/Solitaire_(cipher)
# 
# GENERATE KEYSTREAM
# 1. Key the decks by shuffling or using some secret indicator. (This script, however, will be using UNKEYED decks.)
# 2. Move Joker A one card down, move Joker B two cards down. 
# 3. Perform triple cut around Jokers.
# 4. Perform count cut using bottom cards value.
# 5. Convert the top card to it's value and count down that many cards to find the first key
# 6. Repeat 2 - 5 for the rest of the keys

def solitaire_keystream(length)
    deck = (1..52).to_a << "A" << "B"
    keystream = []
    wrap = Proc.new {|pos| pos > 53 ? pos - 53 : pos}
    
    until keystream.length == length do
        deck.insert(wrap[deck.index("A") + 1],deck.delete_at(deck.index("A")))
        deck.insert(wrap[deck.index("B") + 2],deck.delete_at(deck.index("B")))
        bottom_J = [deck.index("A"),deck.index("B")].max + 1
        bottom_slice = bottom_J > 53 ? nil : deck.slice!(bottom_J..-1)
        top_J = [deck.index("A"),deck.index("B")].min - 1
        deck += deck.slice!(0..top_J) unless top_J < 0
        deck.insert(0,*bottom_slice)
        deck.insert(-2,*deck.slice!(0..(deck[-1]-1)))
        if deck[0].is_a?(Fixnum)
            keystream << deck[deck[0]] unless deck[deck[0]].is_a?(String)
        else
            keystream << deck[53] unless deck[53].is_a?(String)
        end
    end
    keystream
end
