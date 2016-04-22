class GameplayController < ApplicationController

  #Controller for countdown page
  def countdown

    #Gets topics
    topics = getTopics()

    # Gets starting topics
    @topic1 = topics[0]
    @topic2 = topics[1]

    # Gets names of topics to display
    @topic1_name = @topic1.name
    @topic2_name = @topic2.name

    # Gets urls of topics to display
    @topic1_url = @topic1.hyperlink
    @topic2_url = @topic2.hyperlink

    #Sets the start and end times for the game
    @start_time = Time.now.to_i
    @end_time = Time.now.to_i + 3 * 60

    local_page =Nokogiri::HTML(open( "https://en.wikipedia.org/wiki/" + @topic2_url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE} )) #Barack_Obama
    paragraphs = local_page.xpath('//p')
    @first_para = paragraphs.first.text


  end


  #Main gameplay controller
  def wikigame

    #Gets variables for collecting new topics
    global_db_counter = TopicPair.find_by_pair("global")
    current_plays = global_db_counter.count
    current_refresh = global_db_counter.refresh
    refresh = false

    #Gets the new start time for the timeer
    new_start = Time.now.to_i


    #Calculates the time left
    @time_left = params[:end].to_i - params[:start].to_i + 2

    #Gets the start and end topics that have been specified
    @topic1 = params[:topic1]
    @topic2 = params[:topic2]

    #Gets the hyperlinks for the two topics in question
    @start_obj = Topic.find_by_hyperlink( params[:topic1] )
    @end_obj = Topic.find_by_hyperlink( params[:topic2 ] )

    #Gets and splits the current path into items
    @current_path = params[:current_path]
    @current_item = @current_path.split("->").last


    #Gets hyperlink of current object and compares to end hyperlink
    #curr_obj = Topic.find_by_name( @current_item )

    #If it is a match, player has won
    if @current_item == params[:topic2] then
      redirect_to :controller => "main", :action => "finished", :win => "true", :time_left => @time_left,
                  :topic1 => params[:topic1], :topic2 => params[:topic2], :current_path => params[:current_path]
    end

    #Get the names and hyperlinks of start and finish objects
    @topic1_name = @start_obj.name
    @topic2_name = @end_obj.name

    @topic1_link = @start_obj.hyperlink
    @topic2_link = @end_obj.hyperlink

    #Gets the relevant wikipedia page and extracts all links
    local_page =Nokogiri::HTML(open( "https://en.wikipedia.org/wiki/" + @current_item, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE} )) #Barack_Obama
    @links = local_page.xpath('//a[@href]')
    valid_links = []

    #Gets list of all hyperlinks
    current_db_links = Topic.select(:hyperlink)

    topic_list_index = (0..200).to_a.shuffle.take(10)
    puts topic_list_index

    #Updates db with paths if not the first run
    if params[:first] == "false" then
      current_paths = Path.select(:path)

      #Updates with raw path
      updatePaths( current_paths, @current_path )

      split_path = @current_path.split("->")

      #Checks to see if there are at least three links
      if split_path.length >= 3 then

        #Sets initial index to 1
        current_index = 1

        #Continues until the end of the string
        while current_index <= split_path.length - 2 do

          #Gets first element in te subpath
          sub_path = split_path[current_index]
          sub_index = current_index

          #Builds subpath starting at the new subindex
          while sub_index <= split_path.length - 2 do
            sub_path += "->" + split_path[sub_index + 1 ]
            sub_index += 1
          end

          #Updates path repository
          updatePaths( current_paths, sub_path)
          current_index += 1

        end

      end

    else

      #If it is the first run, increment appropriate counters
      Topic.increment_counter(:start_count, @start_obj.id)
      Topic.increment_counter(:end_count, @end_obj.id)
      TopicPair.increment_counter(:count, 1)

      #Checks to see if new topics need to be found
      if current_plays == 5 ** current_refresh then
        refresh = true

        TopicPair.increment_counter(:refresh, 1)
      end

    end


    new_count = 0


    # Scrapes for new topics and adds to list
    @links.each do |link|

      #Checks if link is nill
      if ( !link.nil? ) then

        #Gets local link
        local_url = link['href']


        if (local_url) then


          #Checks to see if local wikipedia site
          if local_url.split("/").second == 'wiki' then

            #Gets url name
            db_url = local_url.split("/").last

            #Excludes pages with colons
            #These are typically category sites
            if db_url.include?(':') == false then



              #Sets first variable to valse and adds new url
              temp_string =  request.url.sub('first=true', 'first=false') + "->" + db_url

              #Updates start time
              link['href'] = temp_string.sub(/start=[0-9]*/, "start=" + new_start.to_s)

              #Adds to list of links allowed on the page
              valid_links.push(local_url)

              new_count += 1

              #Checks to see if topic exists in database
              next if current_db_links.include?(db_url) or topic_list_index.include?(new_count-1) == false

              #If indicated, get new topics
              if refresh == true then
                #Adds topic if not already in db
                Topic.create( :name => link.attr('title'), :hyperlink => db_url, :start_count => 0, :end_count => 0)


              end



           end

            #Removes any link that is not a reference to a section in the current page
          elsif !local_url.include?("#")
            link.remove
          end


        end

      end

    end

  @page = local_page

  end
end
