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
end


#actions:
class DealCards
end

class Hit
end

class Stay
end

deck = Deck.new

player = Player.new("Tyler")
player.add_card(deck.deal_one)
player.add_card(deck.deal_one)
player.add_card(deck.deal_one)
player.show_hand
player.busted?

dealer = Dealer.new
dealer.add_card(deck.deal_one)
dealer.add_card(deck.deal_one)
dealer.add_card(deck.deal_one)
dealer.show_hand
dealer.busted?



