require_relative "dealerHand.rb"

class Dealer
  attr_reader :hand

  def initialize()
    @hand = DealerHand.new()
  end
end
