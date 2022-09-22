require_relative 'bank'
require_relative 'dealer'
require_relative 'deck'
require_relative 'player'
require_relative 'user'

ACTIONS = <<~ACTIONS
  Введите одну из команд, указанных ниже, для продолжения:
  1 - Пропустить
  2 - Взять карту
  3 - Открыть карты
  4 - Завершить игру
ACTIONS

class Blackjack
  attr_reader :bank, :dealer, :deck, :player, :players
  attr_accessor :current_player, :moves

  def initialize
    @bank = Bank.new
    @dealer = Dealer.new('Дилер')
    puts 'Данный проект представляет из себя абстракцию популярной карточной игры'
    puts 'Black Jack. Ваша задача - обыграть дилера, набрав большее число очков,'
    puts 'но не более 21. Удачи;)'
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
    @current_player = if current_player.eql?(player)
                        dealer
                      else
                        player
                      end
  end

  # метод определения числа пропусков хода
  def check_player
    if @moves < 1
      switch_player
      @moves += 1
    else
      raise ArgumentError, 'Вы не можете пропустить ход. Выберите другую команду'
    end
  end

  def take_cards
    players.each { |plr| 2.times { plr.cards_take(deck.cards.pop) } }
  end

  # метод первой ставки игроками
  def first_bet
    players.each { |plr| plr.bet }
  end

  # метод пополнения банка
  def top_up_bank
    bank.value += 20
  end

  def choice(menu = nil)
    puts menu if menu
  end

  def intro
    puts 'Добро пожаловать в игру Black Jack!'
  end

  def start
    @deck = Deck.new
    @moves = 0
    take_cards
    first_bet
    top_up_bank
    @current_player = player
    intro
    black_jack
  end

  def black_jack
    loop do
      players.each { |plr| plr.cards_show }
      dealer_move if current_player.eql?(dealer)
      open_cards if open_time?
      choice(ACTIONS)
      case option
      when 1 then check_player
      when 2 then add_card
      when 3 then open_cards
      when 4 then ending
                  exit
      else
        raise ArgumentError, 'Команда введена неправильно. Используйте номер команды от 1 до 4'
      end
    end
  rescue ArgumentError => e
    p "Ошибка: #{e.message}"
    puts '-------' * 10
    retry
  end

  def add_card
    if current_player.cards_count?
      current_player.cards_take(deck.cards.pop)
      @moves += 1
      switch_player
    else
      raise ArgumentError, 'Вы не можете взять карту. Выберите другую команду'
    end
  end

  def open_time?
    player.cards.size > 2 && dealer.cards.size > 2
  end

  def open_cards
    puts '-------' * 10
    dealer.cards_open
    player.cards_show
    winner_is
  end

  def dealer_move
    if current_player.cards_score < 17 && current_player.cards_count?
      add_card
    elsif current_player.cards_score >= 17 && moves < 2
      switch_player
    elsif current_player.cards_score >= 17 && moves > 2
      open_cards
    end
  end

  def winner_plr
    (dealer.score_over? && player.score_normal) || ((player.cards_score > dealer.cards_score) && player.score_normal)
  end

  def winner_dlr
    (player.score_over? && dealer.score_normal) || ((dealer.cards_score > player.cards_score) && dealer.score_normal)
  end

  def draw
    (player.cards_score == dealer.cards_score) || (player.score_over? && dealer.score_over?)
  end

  def winner_is
    if winner_plr
      puts
      puts "#{player.name} выиграл!"
      player.money += bank.value
    elsif winner_dlr
      puts
      puts "#{dealer.name} выиграл!"
      dealer.money += bank.value
    elsif draw
      puts
      puts 'Ничья!'
      players.each { |plr| plr.money += bank.value / 2 }
    end
    puts
    balance
    puts
    restart
  end

  def balance
    puts "Баланс игроков: #{player.name} - #{player.money}$, #{dealer.name} - #{dealer.money}$"
  end

  def ending
    puts "Игра завершена со счетом #{player.name}: #{player.money}$, #{dealer.name}: #{dealer.money}$"
    puts '-------' * 10
  end

  def restart
    puts 'Попробуете еще раз? Введите 1 для продолжения или любой другой символ для завершения игры'
    input = gets.chomp.to_i
    case input
    when 1
      if !lose
        players.each { |plr| plr.cards = [] }
        bank.value = 0
        start
      else
        player_lose = players.select { |plr| plr.money.zero? }
        puts "У игрока #{player_lose.first.name} недостаточно финансов для продолжения игры!"
        puts
        ending
        exit
      end
    else
      ending
      exit
    end
  end

  def lose
    players.map { |plr| plr.no_money }.include?(true)
  end
end

Blackjack.new.start
