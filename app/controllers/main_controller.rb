class MainController < ApplicationController
  def welcome
  end

  def finished

    if params[:win] == "false" then
      @welcome_text = "Sorry, You Lose :("
    else
      @welcome_text = "YOU WIN!"
      @base_score = 100
      @bonus = params[:time_left].to_i * 10
      @final_score = @base_score + @bonus
    end
  end
end
