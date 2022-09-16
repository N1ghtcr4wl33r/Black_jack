class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit, @value = suit, value
  end

  # методы определения ценности туза и 'картинок'
  def pic?
    %w[J Q K].include?(value)
  end
  
  def ace?
    value == 'A'
  end

  def to_s
    '#{value}-#{suit}'
  end
end
