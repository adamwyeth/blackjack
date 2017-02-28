class Hand

  attr_reader :split
  attr_accessor :parent

  def initialize()
    @cards = []
    @split = false
  end

  def add_card(card)
    @cards << card
  end

  def clear()
    @cards = []
    @split = false
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
    return split_count() == 0 && @cards.length == 2 && value == 21
  end

  def busted?
    return value > 21
  end

  def splittable?
    if !@split && @cards.length == 2 && split_count() < 4
      @cards[0].value == @cards[1].value
    else
      false
    end
  end 

  def split_hand()
    if @split || @cards.length != 2
      raise "Hand not splittable"
    end

    @split = true
    split1 = init_split(@cards[0], self)
    split2 = init_split(@cards[1], self)

    @cards = [split1, split2]
    return @cards
  end

  def init_split(card, parent)
    split = Hand.new()
    split.add_card(card)
    split.parent = parent
    return split
  end


  def split_count()
    if !@split && @parent == nil
      0
    elsif !@split
      return @parent.split_count()
    else
      return split_count_helper()
    end
  end

  def to_s
    card_names = @cards.map do |card|
      card.name
    end
    "[#{card_names.join(",")}] with value #{value}"
  end

  def length()
    return @cards.length
  end

  def split_first()
    return @cards[0]
  end

  def split_second()
    return @cards[1]
  end

  protected
  def split_count_helper()
    if !@split
      return 1
    else
      return @cards[0].split_count_helper() + @cards[1].split_count_helper()
    end
  end


end
