class ColoradoLottery
  attr_reader :registered_contestants,
              :winners,
              :current_contestants

  def initialize
    @registered_contestants = {}
    @winners = []
    @current_contestants = {}
  end

  def interested_and_18?(contestant, game)
    # .age and .game_interests are initialize-methods for the contestant class
    # the hash of info first goes into the contestant class and the methods are created there...
    contestant.age >= 18 && contestant.game_interests.include?(game.name) == true
  end

  def can_register?(contestant, game)
    interested_and_18?(contestant, game) && 
    (!contestant.out_of_state? || game.national_drawing?)
      # A contestant #can_register? if they are interested in the game, 
      # 18 years of age or older, and they are either a Colorado resident 
      # or this is a national game
  end

  def register_contestant(contestant, game)
    if can_register?(contestant, game) 

      # This line says if the game doesn't exsist already create a new key-value for it
      # the key is the game.name & the value is an empty []
      if @registered_contestants[game.name].nil?
        # the line below is creating a new key-value pair:
        @registered_contestants[game.name] = []
      end

      # this says put contestant into the proper key/game
      # if that key/game already exists
      @registered_contestants[game.name] << contestant
    end
  end

  def eligible_contestants(game)
    # .find_all returns an array 
    @registered_contestants[game.name].find_all do |contestant|
      contestant.spending_money >= game.cost
    end
    # `#eligible_contestants` is a list of all the contestants 
    # who have been registered to play a given game and that 
    # have more spending_money than the cost.
  end

  def charge_contestants(game)
    eligible_contestants(game).each do |contestant|
      contestant.spending_money -= game.cost

      if @current_contestants[game].nil? 
        @current_contestants[game]= []
      end

      @current_contestants[game] << contestant.full_name
    end
  end
end