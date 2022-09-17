require_relative 'bank'
require_relative 'dealer'
require_relative 'deck'
require_relative 'player'

class Blackjack
  attr_reader :bank, :dealer, :deck, :player

  def initialize
    @bank, @dealer, @deck = Bank.new, Dealer.new, Deck.new
  end

  def start
    puts 'Введите Ваше имя:'
    name = gets.chomp
    @player = Player.new(name)
    2.times { player.cards_take(deck) }
    2.times { dealer.cards_take(deck) }
    player.bet
    dealer.bet
    bank.value += 20
  end
end

Blackjack.new.start