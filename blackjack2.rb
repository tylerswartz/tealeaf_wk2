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
    end
    scramble!
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

  def busted?
    total > 21
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

  def dealer_play
    while total < 16
      dealer.show_hand
      dealer.add_card(deck.deal_one)
      puts "Dealer hits and draws a: #{card}"
      puts "Dealer's total is now: #{total}"
      if total > 21
        puts "Congrats, the dealer busted. You win!"
        exit
      elsif total == 21
        puts "Sorry, but dealer got blackjack. You lose."
        exit
      end
    end
  end
end


# Game Engine

puts "Welcome to Blackjack"
puts "Are you ready to play a game? (Y/N)"

answer = gets.chomp

if answer == 'N'
  exit
end

puts "First, please enter your name..."

player_name = gets.chomp

puts "Alright #{player_name}, let's get started"

deck = Deck.new
player = Player.new("#{player_name}")
dealer = Dealer.new

player.add_card(deck.deal_one)
player.add_card(deck.deal_one)
player.show_hand

player.add_card(deck.deal_one)
#puts "The dealer is showing #{card}"

puts "What would you like to do? H for Hit or S for Stay?"

action = gets.chomp

if action.upcase == 'H'
  player.add_card(deck.deal_one)
  player.show_hand
    if player.busted? == true
      puts "Sorry you busted"
      dealer.add_card(deck.deal_one)
      dealer.show_hand
      exit
    end
elsif action.upcase == 'S'
  dealer.add_Card(deck.deal_one)
  dealer.dealer_play
end


player.show_hand
dealer.show_hand


# if handtotal > dealertotal
#   puts "You win!! Great Job"
# elsif dealertotal > handtotal
#   puts "Sorry, but the dealer won..."
# else dealertotal == handtotal
#   puts "sorry, tie goes to the house...you lose"
# end





