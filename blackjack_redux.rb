class Card
	attr_accessor :value, :suit

	def initialize(v,s)
		@value = v
		@suit = s
	end

	def card_output
		puts "=> The #{@value} of #{@suit}"
	end

	def to_s
		card_output
	end
end

class Deck
	attr_accessor :cards

	def initialize
		@cards = []
	
		['2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace'].each do |value|
      ['Hearts','Diamonds','Spades','Clubs'].each do |suit|
        @cards << Card.new(value, suit)
			end
		end
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
	attr_accessor

	def initialize
	end

	def show_hand
		puts "--- #{@name}'s Hand ---"
		cards.each do|card|
			"=> #{card}"
		end
		puts "=> Total is: #{total}"
	end

	def add_card(new_card)
		cards << new_card
	end

	def total
		value = cards.map{|card| card.value}
    total = 0
  
    value.each do |v|
      if v == 'Ace'
        total = total + 11
      elsif v.to_i == 0
        total = total + 10
      else
        total = total + v.to_i
      end
    end
  
    value.select{|v| v == "Ace"}.count.times do
      total = total - 10 if total > 21
    end
   
    return total  
	end

	def is_busted?
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

	def show_flop
		puts "--- Dealer's Hand ---"
		puts "=> The first card is hidden"
		"=> #{@cards[1]}"
	end
end


#game engine

class Blackjack
	attr_accessor :deck, :player, :dealer

	def initialize
		@deck = Deck.new
		@player = Player.new('Player1')
		@dealer = Dealer.new
	end

	def add_player
		puts "Welcome to Blackjack, please enter your name"
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

	def player_action
		puts "#{player.name}'s turn."

		hit_blackjack?(player)
		while !player.is_busted?
			puts "What would you like to do? H for Hit, S for Stay."
			response = gets.chomp

			if !['H','S'].include?(response)
				puts "Error: Please enter an uppercase H or S"
				next

			if response == 'S'
				puts "You chose to stay."
				break
			end

			if response == 'H'
				new_card = deck.deal_one
				puts "Dealing card to #{player.name}..."
				"#{new_card}"
				player.add_card(new_Card)

	end

	def start
		add_player
		deal_cards
		show_flop
		# player_action
		# dealer_action
		# who_wins?
	end
end

game = Blackjack.new
game.start




# deck = Deck.new
# player = Player.new('Tyler')
# player.add_card(deck.deal_one)
# player.add_card(deck.deal_one)
# player.show_hand

# dealer = Dealer.new
# dealer.add_card(deck.deal_one)
# dealer.add_card(deck.deal_one)
# dealer.show_hand