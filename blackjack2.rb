class Card
  attr_accessor :suit, :face_value

  def initialize(f,s)
    @face_value = f
    @suit = s
  end

  def card_output
    "The #{@face_value} of #{@suit}"
  end

  def to_s
    card_output
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []

    ['2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace'].each do |face_value|
      ['Hearts','Diamonds','Spades','Clubs'].each do |suit|
        @cards << Card.new(face_value, suit)
      end
      scramble!
    end
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}" 
    end
    puts "=> Total is #{total}"
  end

  def total
    face_values = cards.map{|card| card.face_value}
    total = 0
  
    face_values.each do |v|
      if v == 'Ace'
        total = total + 11
      elsif v.to_i == 0
        total = total + 10
      else
        total = total + v.to_i
      end
    end
  
    face_values.select{|v| v == "Ace"}.count.times do
      total = total - 10 if total > 21
    end
   
    return total  
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end

end


class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end
end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_flop
    puts "---- Dealer's Hand ----"
    puts "=> The first card is hidden"
    puts "=> #{cards[1]}"
  end
end


# Game Engine

class Blackjack
  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new("Player1")
    @dealer = Dealer.new
  end

  def set_player_name
    puts "Please enter your name."
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_hand
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hit blackjack. #{player.name} loses."
      else
        puts "Congrats, #{player.name} hit blackjack!"
      exit
      end
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congrats! Dealer busted! #{player.name} wins!"
      else
        puts "#{player.name} busted. Dealer wins."
      end
      play_again?
    end
  end

  def player_turn
    puts "#{player.name}'s turn."

    blackjack_or_bust?(player)

    while !player.is_busted?
      puts "What would you like to do? H for Hit or S for Stay?"
      action = gets.chomp

      if !['H','S'].include?(action)
        puts "Error: you must enter an uppercase H or S"
      next
      end

      if action == 'S'
        puts "#{player.name} chose to stay at #{player.total}"
        break
      end

      new_card = deck.deal_one
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name} total is now: #{player.total}"

      blackjack_or_bust?(player)
    end    
  end

  def dealer_turn
    puts "Dealer's turn."

    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealing card to dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer total is now: #{dealer.total}"

      blackjack_or_bust?(dealer)
    end
    puts
    puts "Dealer's stays at #{dealer.total}"
  end

  def who_won?
    if player.total > dealer.total
      puts "Congrats. #{player.name} wins!"
    elsif player.total < dealer.total
      puts "Sorry, dealer wins."
    else
      puts "It's a tie..."
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? Y for Yes, N for No"
    
    if gets.chomp == 'Y'
      puts "Starting new game..."
      puts ""
      deck = Deck.new_card
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Thanks for playing. Goodbye!"
      exit
    end
  end

  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = Blackjack.new
game.start

