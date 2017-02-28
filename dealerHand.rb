require_relative "hand.rb"

class DealerHand < Hand

  def showing
    card_names = @cards[1..-1].map do |card|
      card.name
    end
    "[" + card_names.join(",") + "]"
  end
end
