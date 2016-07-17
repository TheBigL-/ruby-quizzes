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
    deck = (1..54).to_a
end
