class Card
  def initialize(f,s)
    @face_value = f
    @suit = s
  end

  def card_output
    puts "The card is a #{@face_value} of #{@suit}"
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

class Player
end

class Dealer
end

class Hand
end

class DealCards
end

class Hit
end

class Stay
end

deck = Deck.new
puts deck.cards

puts deck.cards.size
