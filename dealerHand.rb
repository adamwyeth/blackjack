require_relative "hand.rb"

#Adds showing method to hand, which prints all but the first card for the dealer
class DealerHand < Hand

  def showing
    card_names = @cards[1..-1].map do |card|
      card.name
    end
    "[" + card_names.join(",") + "]"
  end
end
