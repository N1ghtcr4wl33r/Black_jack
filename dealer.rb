require_relative 'player'

class Dealer < Player
  def cards_show
    puts "#{self.name} карты: "
    puts "|#|" * cards.size
  end

  # метод вскрытия карт
  def cards_open
    puts "#{self.name} карты: "
    cards.each { |card| print "|#{card}|" }
    puts "Очки: #{self.cards_score}"
  end
end