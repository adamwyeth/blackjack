require_relative 'hand.rb'

class Player
  attr_reader :name, :chips, :hand, :bet

  def initialize(name, chips)
    @name = name
    @chips = chips
    @hand = Hand.new()
  end

  def make_bet(bet_amt)
    
    raise "Insufficient chips for bet" if bet_amt > @chips
    
    @chips -= bet_amt
    @bet = bet_amt
  end

  def push()
    @chips += @bet
  end

  def win(blackjack)
    bet_multiplier = blackjack ? 2.5 : 2
    chips_won = (@bet * bet_multiplier).to_i
    @chips += chips_won
    chips_won
  end

  def double()
    @bet *= 2
    @chips -= @bet
  end

  def to_s
    "#{@name} has #{chips} chips"
  end

end
