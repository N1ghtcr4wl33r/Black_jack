require_relative 'card'

class Player
  attr_reader :name
  attr_accessor :money, :cards

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

  # метод взятия карты с колоды
  def cards_take(card)
    cards << card
  end
  
  # методы определения количества очков игрока
  def score_normal
    cards_score <= 21
  end

  def score_over?
    cards_score > 21
  end

  # метод проверки отсутствия финансов у игрока
  def no_money
    money == 0
  end

  # метод определения числа карт игрока
  def cards_count?
    cards.size < 3
  end
end




