class StaticController < ApplicationController
  before_filter :current_user  
  before_filter :client, :only => [:tweetverse]

  def tweetverse
    #tweeting random @gospelr bible verse
    if request.url.index('localhost')
      @verse = Verse.find(:first, :order => "RAND()")
    else
      @verse = Verse.find(:first, :order => "RANDOM()")
    end 
  
    @link = "#{@verse.book_name}/#{@verse.chapter.to_s}/#{@verse.number.to_s}"
  
    if @verse.text.length > 100
      message = @verse.text[0..99] + "... http://gospelr.com/#{@link}"
    else
      message = @verse.text + " http://gospelr.com/#{@link}"
    end
        
    # gospelr = User.find_by_username('gospelr')
    
    @client.update(message)
    
    render :text => '200'
    
  end
end
