class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  #Function that gets topics for the start of the game
  def getTopics()


    #Randomizes topics selected
    Random.new_seed
    topic_entries = Topic.find_each.entries
    entry_count = topic_entries.length

    #Seeds initial random numbers
    random_topic1_index = rand(entry_count)
    least_topic1_index = 0
    random_topic2_index = rand(entry_count)
    least_topic2_index = 0

    #Assumes at least two topics in db at all times
    least_start = topic_entries[0]
    least_end = topic_entries[1]
    least_start_count = 0
    least_end_count = 0

    #Selects least used entry
    index1 = 0
    topic_entries.each do |entry|
      if entry.start_count <= least_start_count then
        least_start = entry
        least_start_count = entry.start_count
        least_topic1_index = index1
      end
      index1 += 1
    end

    #Selects least used entry
    index2 = 0
    topic_entries.each do |entry|
      if entry.end_count <= least_end_count and entry != least_start then
        least_end = entry
        least_end_count = entry.end_count
        least_topic2_index = index2
      end
      index2 += 1
    end


    final_topic1 = least_start
    final_topic2 = least_end

    topic1_index = 0

    #Adds random element to start end so that about 1/4 of the time
    #random start is used
    if random_topic1_index % 2 == 0 && least_topic1_index %2 == 0 then
      final_topic1 = topic_entries[random_topic1_index]
      topic1_index = random_topic1_index
    end

    #Same with random end
    if random_topic2_index % 2 == 0 && least_topic2_index %2 == 0 then
      while topic1_index == random_topic2_index do
        random_topic2_index = rand(entry_count)
        final_topic2 = topic_entries[random_topic2_index]
      end
    end

    #Creates list for output
    topic_list = [ final_topic1, final_topic2]

    return topic_list

  end

  def updatePaths ( current_paths, path )
    #Updates path in database

    if current_paths.include?(path) == false
      Path.create( :path => path, :count => 1)
    else
      selected_path = Path.find_by_path(path)
      selected_path.increment(:count, 1)
    end
  end

end
