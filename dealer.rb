require_relative "dealerHand.rb"

#Container for dealer hand
class Dealer
  attr_accessor :hand

  def initialize()
    @hand = DealerHand.new()
  end
end
