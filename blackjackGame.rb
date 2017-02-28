require_relative "dealerHand.rb"
require_relative "deck.rb"
require_relative "player.rb"
require_relative "dealer.rb"

class BlackjackGame

  def initialize(min_bet)
    @min_bet = min_bet
    @players = []
    @dealer = Dealer.new()
  end

public
  def play()  
    enter_players()

    game_loop()
    puts "Thank you for playing blackjack!"
    if players_left 
      puts "Final Results:"
      chip_counts()
    end
  end
 
private 
  def game_loop()
    q_flag = ""
    while players_left && q_flag.downcase != "q"
      chip_counts()
      enter_bets()
      
      deck = Deck.new()
      deal_round(deck) 
      
      display_hands()

      play_hands(deck)

      adjust_chips_after_round()

      clear_losers()
      
      clear_hands()
      print "q to quit. Anything else to play another round!: "
      q_flag = gets.strip
      putc "\n"

    end
  end

  def deal_round(deck)

    #deal two cards
    for i in 1..2
      @dealer.hand.add_card(deck.draw())
      @players.each do |player|
        player.hand.add_card(deck.draw())
      end
    end
  end


  def enter_players()
    puts "Welcome to blackjack!"
    print "How many players would you like to play with? (1-5): "
    player_count = gets.strip.to_i
    while ![1,2,3,4,5].include? player_count
      print "That was not a valid entry! Please enter a value between 1 and 5: "
      player_count = gets.strip.to_i
    end
    putc "\n"

    for i in 1..player_count
      @players.push(enter_player(i))
    end
  end

  def enter_player(player_number)
    print "What is player #{player_number}'s name?: "
    player_name = gets.strip
    while player_name.length == 0
      print "Player name cannot be blank: "
      player_name = gets.strip
    end
    print "How many chips does this player have? (Min: #{@min_bet}, Max: #{@min_bet * 100}): "
    chip_count = gets.strip.to_i
    while @min_bet > chip_count || chip_count > @min_bet * 100
      print "That is not a valid amount. Please try again: "
      chip_count = gets.strip.to_i
    end
    putc "\n"

    return Player.new(player_name, chip_count)
  end

  def enter_bets()
    @players.each do |player|
      enter_bet(player)
    end
  end

  def enter_bet(player)
    print "How much would #{player.name} like to bet? #{valid_bet_string(player.chips)}: "
    bet = gets.strip.to_i
    while bet < @min_bet || bet > player.chips
      print "That's not a valid bet! #{valid_bet_string(player.chips)} Please try again: "
      bet = gets.strip.to_i
    end
    
    player.make_bet(bet)
  end

  def play_hands(deck)

    if @dealer.hand.blackjack?
      puts "Dealer has a blackjack!"
      return
    end

    @players.each do |player|
      play_hand(player, deck)
    end

    puts "Dealer will play now"
    puts "Dealer has: #{@dealer.hand}"
    while @dealer.hand.value < 17
      @dealer.hand.add_card(deck.draw())
      puts "Dealer has: #{@dealer.hand}"
      sleep 2
    end
  end

  def play_hand(player, deck)
    commands = ["h", "s", "d"]
    command = ""
    puts "#{player.name}, your current hand: #{player.hand}"
    while !player.hand.busted? && command.downcase != "s" && command.downcase != "d"
      puts "What would you like to do, #{player.name}?"
      print "You can hit (h), stand (s), and double (d): "
      command = gets.strip
      while !commands.include? command.downcase
        print "That was not a valid command!. Please try again: "
        command = gets.strip
      end

      case command.downcase
      when "h"
        player.hand.add_card(deck.draw())
        puts "#{player.name} hit and how has: #{player.hand}"
      when "d"
        player.hand.add_card(deck.draw())
        player.double()
        puts "#{player.name} doubled and now has: #{player.hand}"
      when "s"
        puts "#{player.name} stood."
      else
        raise "Invalid command selected while playing hand"
      end
    end
    putc "\n"

  end

  def adjust_chips_after_round()

    @players.each do |player|
      if !player.hand.busted?
        if @dealer.hand.busted? || player.hand.value > @dealer.hand.value
          player.win()
          puts "#{player.name} won #{player.bet * 2} chips!"
        elsif @dealer.hand.value == player.hand.value
          player.push()
          puts "#{player.name} pushed." 
        else
        puts "#{player.name}'s hand was worth less than the dealer's"
        end
      else
      puts "#{player.name} busted this round"
      end
    end
  end

  def clear_losers()
    @players.delete_if do |player|
      if player.chips < @min_bet
        puts "#{player.name} no longer has sufficient chips to place a minimum "\
        "bet and has been eliminated!"
      end
      player.chips < @min_bet
    end
  end

  def chip_counts()
    puts @players
  end
  
  def player_count
    @players.length
  end

  def display_hands()
    puts "Dealer showing: #{@dealer.hand.showing()}\n"
    puts "Player hands: "
    @players.each do |player|
      puts "#{player.name}: #{player.hand}"
    end
    putc "\n"
  end

  def players_left
    return @players.length > 0
  end

  def clear_hands()
    @dealer.hand.clear()
    @players.each do |player|
      player.hand.clear()
    end
  end

  def valid_bet_string(chips)
    "(Min: #{@min_bet}, chips: #{chips})"
  end
end 
