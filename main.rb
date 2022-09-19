require_relative 'bank'
require_relative 'dealer'
require_relative 'deck'
require_relative 'player'
require_relative 'user'

class Blackjack
  attr_reader :bank, :dealer, :deck, :player, :players
  attr_accessor :current_player

  ACTIONS = [
    {number: 1, message: 'Пропустить'},
    {number: 2, message: 'Взять карту'},
    {number: 3, message: 'Открыть карты'},
    {number: 4, message: 'Завершить игру'}
  ]

  def initialize
    @bank, @dealer = Bank.new, Dealer.new('Дилер')
    puts 'Введите Ваше имя:'
    @player = User.new(input)
    @players = []
    @players.push(dealer, player)
  end

  def input
    gets.chomp
  end

  def option
    gets.chomp.to_i
  end

  def switch_player
    if current_player.eql?(player)
      @current_player = dealer
    else
      @current_player = player
    end
  end

  def check_player
    switch_player
  end

  def take_cards
    players.each {|plr| 2.times {plr.cards_take(deck.cards.pop)}}
  end

  def start
    @deck = Deck.new
    take_cards
    players.each {|plr| plr.bet}
    bank.value += 20
    @current_player = player
    puts 'Добро пожаловать в игру Black Jack!'
    puts "Введите одну из команд, указанных ниже, для продолжения:"
    black_jack
  end

  def black_jack
    loop do
      players.each {|plr| plr.cards_show}
      dealer_move if current_player.eql?(dealer)
      open_cards if open_time?
      ACTIONS.each do |a|
        puts "#{a[:number]}: #{a[:message]}"
      end
      option
      case option
      when 1 then check_player
      when 2 then add_card
      when 3 then open_cards
      when 4 then exit
      else
        raise ArgumentError, 'Команда введена неправильно. Используйте номер команды от 1 до 4'
      end
    end
  rescue ArgumentError => e
    p 'Ошибка: #{e.message}'
    retry
  end

  def add_card
    if current_player.cards_count?
      current_player.cards_take(deck.cards.pop)
      switch_player
    else
      raise RuntimeError, 'Вы не можете взять карту. Выберите другую команду'
    end
  end

  def open_time?
    player.cards.size > 2 && dealer.cards.size > 2
  end

  def open_cards
    puts '-' * 10
    dealer.cards_open
    player.cards_show
    winner_is
  end

  def dealer_move
    if current_player.cards_score < 17 && current_player.cards_count?
      add_card
    elsif current_player.cards_score >= 17
      switch_player
    end
  end

  def winner_plr
    (dealer.score_over? && player.score_normal) || ((player.cards_score > dealer.cards_score) && (player.score_normal))
  end

  def winner_dlr
    (player.score_over? && dealer.score_normal) || ((dealer.cards_score > player.cards_score) && (dealer.score_normal))
  end

  def draw
    (player.cards_score == dealer.cards_score) || (player.score_over? && dealer.score_over?)
  end

  def winner_is
    if winner_plr
      puts '#{player.name} выиграл!'
      player.money += bank.value
    elsif winner_dlr
      puts '#{dealer.name} выиграл!'
      dealer.money += bank.value
    elsif draw
      puts 'Ничья!'
      players.each {|plr| plr.money += bank.value/2}
    end
    restart
  end

  def restart
    puts 'Попробуете еще раз? Введите 1 для продолжения, 0 для завершения игры'
    if input.to_i = 1 && !lose
      players.each {|plr| plr.cards = []}
      bank.value = 0
      start
    else
      puts 'Игра завершена со счетом #{player.name}: #{player.money}, #{dealer.name}: #{dealer.money}'
      abort 'Недостаточно финансов для продолжения игры!'
    end
  end

  def lose
    players.map {|plr| plr.no_money}.include?(true)
  end
end

Blackjack.new.start