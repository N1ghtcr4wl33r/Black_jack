require_relative 'card'

class Player
  attr_reader :name, :money, :cards

  BUDGET = 100
  BET = 10
  
  def initialize(name)
    @name = name
    @money = BUDGET
    @cards = []
  end

  def bet
    @money -= BET
  end

  # метод подсчета ценности карт игрока
  def cards_score
    score = 0
    cards.each do |card|
    score +=
      if card.ace?
        11
      elsif card.pic?
        10
      else
        card.value
      end
    end
    cards.select { |card| card.ace?}.size.times do
      score -= 10 if score > 21
    end
    score
  end

  def cards_show
    puts '#{self.name}: '
    @cards.each { |card| puts '#{card}'}
  end

  # метод взятия карты с колоды
  def cards_take(deck)
    @cards << deck.cards.pop
    cards_show
  end
  
  # метод ставки
  def make_bet
    @money -= BET
  end
end




