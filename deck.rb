require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = cards_init
  end

  # метод создания колоды
  def cards_init
    cards = []
    suites = %w[♥ ♣ ♦ ♠]
    values = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
    suites.each do |suit|
      values.each do |value|
        cards << Card.new(suit, value)
      end
    end
    cards.shuffle!
  end
end
