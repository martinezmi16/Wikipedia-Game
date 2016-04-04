class GameplayController < ApplicationController
  def countdown

    topics = getTopics()

    # Gets starting topics
    @topic1 = topics[0]
    @topic2 = topics[1]

    # Gets names of topics to display
    @topic1_name = @topic1.name
    @topic2_name = @topic2.name


  end

  def wikigame
  end
end
