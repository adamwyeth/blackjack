class Card
  attr_reader :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def name
    case @rank
    when 1 
      "A"
    when 11
      "J"
    when 12
      "Q"
    when 13
      "K"
    else
      @rank.to_s
    end

  end

  def value
    case @rank
    when 1
      11
    when 11, 12, 13
      10
    else 
      @rank
    end
  end

  def to_s
    "#{name}  of  #{@suit.to_s}s"
  end
end
