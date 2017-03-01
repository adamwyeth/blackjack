require_relative 'hand.rb'

#Container for player hands and chip counts
class Player
  attr_reader :name, :chips, :bet
  attr_accessor :hand

  def initialize(name, chips)
    @name = name
    @chips = chips
  end

  def make_bet(bet_amt)
    
    raise "Insufficient chips for bet" if bet_amt > @chips
    
    @chips -= bet_amt
    @bet = bet_amt
  end

  def push()
    @chips += @bet
  end

  #Pay out 3:2 on blackjack
  #Pay out double on double
  def win(blackjack, double)
    bet_multiplier = blackjack ? 2.5 : (double ? 4 : 2)
    chips_won = (@bet * bet_multiplier).to_i
    @chips += chips_won
    chips_won
  end

  def to_s
    "#{@name} has #{chips} chips"
  end

end
