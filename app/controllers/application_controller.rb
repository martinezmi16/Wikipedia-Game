class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def getTopics()


    #Randomizes topics selected
    Random.new_seed

    topic_entries = Topic.find_each.entries
    entry_count = topic_entries.length
    topic1_index = rand(entry_count)
    topic2_index = rand(entry_count)


    # Ensures the topics are not the same
    while( topic1_index == topic2_index )
      topic2_index = rand( entry_count )
    end


    #Gets topics from list of topics
    topic1 = topic_entries[topic1_index]
    topic2 = topic_entries[topic2_index]

    #Creates list for output
    topic_list = [ topic1, topic2]

    return topic_list

  end

end
