class MainController < ApplicationController
  #Welcome controller
  def welcome
  end

  #Called when the game is finished
  def finished

    #Checks if the player lost
    if params[:win] == "false" then
      @welcome_text = "Sorry, You Lose :("
    else
      #Tells player they won and gives score
      @welcome_text = "YOU WIN!"
      @base_score = 100
      @bonus = params[:time_left].to_i * 10
      @final_score = @base_score + @bonus
    end
  end
end
