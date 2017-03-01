#A hand is either a non-split hand, where @cards is an array of cards
#or a split hand, where @cards contains two split or non-split hands.
#Ultimately, the "leaves" of this setup will be non-split hands.
#Most methods of Hand can only be called on a non-split hand

class Hand

  attr_reader :split, :doubled
  attr_accessor :parent

  def initialize()
    @cards = []
    @split = false
  end

  def add_card(card)
    if @split
      raise "Add card not available on split hand"
    end
    @cards << card
  end

  def clear()
    @cards = []
    @split = false
  end

  #Blackjack value of hand
  def value
    if @split
      raise "Value cannot be calculated for split hand, since multiple values exist"
    end

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

  def doublable?
    return @split == false && @cards.length == 2
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
      return 0
    elsif !@split
      return @parent.split_count()
    else
      return split_count_helper()
    end
  end

  def double_hand()
    if @split
      raise "Can't double split hand"
    end

    @doubled = true
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
