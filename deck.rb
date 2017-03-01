require_relative 'card.rb'

#Represent a deck of cards.
#In this case, the cards are blackjack cards
class Deck
  def initialize()
    @cards = []
    suits = [:spade, :heart, :diamond, :club]
    #13 distinct cards per suit
    for i in 1..13
      suits.map do |suit|
        @cards << Card.new(i, suit)
      end
    end
    @cards.shuffle!
  end

  def draw()
    @cards.shift()
  end
end
