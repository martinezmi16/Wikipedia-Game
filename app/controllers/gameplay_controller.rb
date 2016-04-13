class GameplayController < ApplicationController
  def countdown

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

    @start_time = Time.now.to_i
    @end_time = Time.now.to_i + 1 * 60


  end

  def wikigame


    new_start = Time.now.to_i




    @time_left = params[:end].to_i - params[:start].to_i


    puts @time_left

    @start_obj = Topic.find_by_hyperlink( params[:topic1] )
    @end_obj = Topic.find_by_hyperlink( params[:topic2 ] )
    current_path = params[:current_path]
    @current_item = current_path.split("->").last

    @topic1_name = @start_obj.name
    @topic2_name = @end_obj.name

    @topic1_link = @start_obj.hyperlink
    @topic2_link = @end_obj.hyperlink

    local_page =Nokogiri::HTML(open( "https://en.wikipedia.org/wiki/" + @current_item, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE} )) #Barack_Obama
    @links = local_page.xpath('//a[@href]')
    valid_links = []

    current_db_links = Topic.select(:hyperlink)

    new_count = 0

    # Scrapes for new topics and adds to list
    @links.each do |link|

      if ( !link.nil? ) then
        local_url = link['href']


        if (local_url) then


          #Checks to see if local wikipedia site
          if local_url.split("/").second == 'wiki' then
            #puts local_url
            #Gets url name
            db_url = local_url.split("/").last

            #if db_url.include?(':') == false then

              temp_string =  request.url.sub('first=true', 'first=false') + "->" + db_url
              link['href'] = temp_string.sub(/start=[0-9]*/, "start=" + new_start.to_s)

              #Adds to list of links allowed on the page
              valid_links.push(local_url)

              #Checks to see if topic exists in database
              next if current_db_links.include?(db_url) or new_count > 10

              #Adds topic if not already in db
              Topic.create( :name => link.attr('title'), :hyperlink => db_url, :start_count => 0, :end_count => 0)
              new_count += 1


           # end

          else
            link.remove
          end


        end

      end

    end

  @page = local_page

  end
end
