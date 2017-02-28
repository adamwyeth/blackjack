class Hand
  def initialize()
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def clear()
    @cards = []
  end

  #Blackjack value of hand
  def value
    val = 0
    aces = 0
    @cards.each do |card|
      val += card.value
      aces += card.name == "A" ? 1 : 0
    end

    while val > 21 && aces > 0
      val -= 10
      aces -= 1
    end
    return val
  end

  def blackjack?
    return @cards.length == 2 && value == 21
  end

  def busted?
    return value > 21
  end

  def to_s
    card_names = @cards.map do |card|
      card.name
    end
    "[#{card_names.join(",")}] with value #{value}"
  end
end
