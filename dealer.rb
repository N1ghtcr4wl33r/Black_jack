class Dealer < Player
  def show_cards
    puts '#{self.name}: '
    puts @cards.size
  end

  # метод вскрытия карт
  def open_cards
    puts '#{self.name}: '
    @cards.each { |card| puts '#{card}' }
  end
end