require_relative 'player'

class User < Player
  def initialize(name = gets.chomp)
    super(name)
  end

  def cards_show
    puts "#{self.name} карты: "
    cards.each { |card| print "|#{card}|"}
    puts "Очки: #{self.cards_score}"
  end
end