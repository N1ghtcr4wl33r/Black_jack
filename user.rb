require_relative 'player'

class User < Player
  def initialize(name = gets.chomp)
    super(name)
  end

  def cards_show
    puts "#{name} карты: "
    cards.each { |card| print "|#{card}|" }
    puts "Очки: #{cards_score}"
  end
end
