require_relative 'player'

class Dealer < Player
  def cards_show
    puts "#{name} карты: "
    puts '|#|' * cards.length
  end

  # метод вскрытия карт
  def cards_open
    puts "#{name} карты: "
    cards.each { |card| print "|#{card}|" }
    puts "Очки: #{cards_score}"
  end
end
