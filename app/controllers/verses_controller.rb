class VersesController < ApplicationController
  before_filter :current_user  
  
  # GET /verses
  # GET /verses.json
  def index
    @verses = Verse.paginate :page => params[:page], :conditions => ["book_id = 1"]
    # @verses = Verse.where("book_id = 1")
    
    # if session[:bible].nil?
    #   session[:bible] = Bible.find(:first).id #DEFAULT BIBLE NUMBER
    # end 
    #   
    # @bible = Bible.find(session[:bible])
    # @verses = @bible.verses
    # # @verses = Verse.paginate :conditions => ["bible_id = ?", @bible.id], :page => params[:page], :order => 'id'
    # 
    # @verses = @verses.book(params[:book_id] || 1)
    # # @verses = @verses.chapter(params[:chapter]) if !params[:chapter].nil?
    # 
    # @chapter, @verse = params[:chapter].split(/:/) rescue nil
    # # @verses = @verses.chapter(@chapter) if !params[:chapter].nil?
    # @verses = @verses.chapter(@chapter) if !@chapter.nil?
    # 
    # if !@verse.nil?
    #   @verses = @verses.number(@verse)
    # end
    # 
    # # @verses = @verses.paginate :page => params[:page], :order => 'id'
    # @verses = @verses.paginate :page => params[:page], :order => 'id'
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @verses }
    end
  end

  # GET /verses/1
  # GET /verses/1.json
  def show
    @verse = Verse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @verse }
    end
  end
  
  def search
    if session[:bible].nil?
      session[:bible] = Bible.find(:first).id #DEFAULT BIBLE NUMBER
    end
    @bible = Bible.find(session[:bible])
    if params[:page].nil?
      if params[:search].nil? 
        session[:searchterm] = params[:id]
      else
        session[:searchterm] = params[:search][:searchtext]
      end
    end
    
    if session[:searchterm].index(":")
      # Goto John 3:15 or 3John 1:1
      
      txt=session[:searchterm]

      re1='((?:[0-9]*[a-z][a-z]+))' # Word 1
      re2='(\\s+)'  # White Space 1
      re3='(\\d+)'  # Integer Number 1
      re4='(:)' # Any Single Character 1
      re5='(\\d+)'  # Integer Number 2

      re=(re1+re2+re3+re4+re5)
      m=Regexp.new(re,Regexp::IGNORECASE);
      if m.match(txt)
          word1=m.match(txt)[1];
          ws1=m.match(txt)[2];
          int1=m.match(txt)[3];
          c1=m.match(txt)[4];
          int2=m.match(txt)[5];
          # puts "("<<word1<<")"<<"("<<ws1<<")"<<"("<<int1<<")"<<"("<<c1<<")"<<"("<<int2<<")"<< "\n"
          
          # if book = 1John then change to 1 John
          book = word1.gsub("1", "1 ")
          book = book.gsub("2", "2 ")
          book = book.gsub("3", "3 ")
          
          # redirect_to(bibles_show_chapter_path(params[:id], Verse.find(:first, :conditions => ["book_name LIKE ?", "#{book}%"]).book_id, int1))
          
          # http://gospelr.com/quote/1_john/2/1 = 1john 2:1
          # http://localhost:3000/bibles/6/62/5
          bookid = Verse.find(:first, :conditions => ["book_name = ?", "#{book}"]).book_id rescue nil
          if bookid.nil?
            # book/chapter/verse not found - continue with the search - TODO DRY
            
            if request.url.index('localhost')
              @versecount = Verse.count(:all, :conditions => ["text LIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]])
             else
               @versecount = Verse.count(:all, :conditions => ["text ILIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]])
            end
            

            if request.url.index('localhost')
              @verses = Verse.paginate(:conditions => ["text LIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]], 
              :per_page => 10,
              :page => params[:page])
             else
               @verses = Verse.paginate(:conditions => ["text ILIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]], 
               :per_page => 10,
               :page => params[:page])
            end


          else
            
            # redirect_to("/bibles/#{@bible.id}/#{bookid}/#{int1}")
            redirect_to("/#{book}/#{int1}/#{int2}")
          end
      else
        
        # book/chapter/verse not found - continue with the search - TODO DRY
        if request.url.index('localhost')
          @versecount = Verse.count(:all, :conditions => ["text LIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]])
         else
           @versecount = Verse.count(:all, :conditions => ["text ILIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]])
        end
        
        if request.url.index('localhost')
          @verses = Verse.paginate(:conditions => ["text LIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]], 
          :per_page => 10,
          :page => params[:page])
         else
           @verses = Verse.paginate(:conditions => ["text ILIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]], 
           :per_page => 10,
           :page => params[:page])
        end

      end
      
    else  
    
      if request.url.index('localhost')
         @versecount = Verse.count(:all, :conditions => ["text LIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]])
       else
         @versecount = Verse.count(:all, :conditions => ["text ILIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]])
      end
    
      if request.url.index('localhost')
        @verses = Verse.paginate(:conditions => ["text LIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]], 
        :per_page => 10,
        :page => params[:page])

        # @verses = Verse.find(:all, 
        # :conditions => ["text LIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]])

       else
         @verses = Verse.paginate(:conditions => ["text ILIKE ? and bible_id = ?", '%' + session[:searchterm] + '%', session[:bible]], 
         :per_page => 10,
         :page => params[:page])
      end
    
      # render :action => 'show'
    end        
  end
  
  def jump
    if session[:bible].nil?
      session[:bible] = Bible.find(:first).id #DEFAULT BIBLE NUMBER
    end
    book = params[:book]
    if isNumeric(book)
      ebook = Verse.find(:first, :conditions => ['book_id = ?', book])
      book = ebook.book_name
    elsif !params[:chapter].nil?
      # if book = 1John then change to 1 John
      book = book.gsub("1", "1 ")
      book = book.gsub("2", "2 ")
      book = book.gsub("3", "3 ")      
    end

    chapter = params[:chapter]
    if chapter.nil?
      chapter = 1
    end
    verse = params[:verse]
    
    @searchterm = book + " " + chapter + ":" + verse rescue ""
    
    
    if verse.to_i > 1 
      verse = verse.to_i - 2
    end

    if verse.nil?
      @verses = Verse.paginate(:conditions => ["book_name = ? and bible_id = ? and chapter >= ?", book, session[:bible], chapter], 
      :page => params[:page])

      # @verses = Verse.find(:all, 
      # :conditions => ["book_name = ? and bible_id = ? and chapter >= ?", book, session[:bible], chapter])

    else
      @verses = Verse.paginate(:conditions => ["book_name = ? and bible_id = ? and chapter >= ? and number >= ?", book, session[:bible], chapter, verse], 
      :page => params[:page])      

      # @verses = Verse.find(:all, 
      # :conditions => ["book_name = ? and bible_id = ? and chapter >= ? and number >= ?", book, session[:bible], chapter, verse])

    end
  
    render :action => 'index'
        
  end
  
  def highlight
    
    @highlight = Comment.find(:first, :conditions=>['user_id = ? and verse_id = ? and color IS NOT NULL', current_user.id, params["id"]])
    if !@highlight 
      @highlight = Comment.new
      @highlight.user_id = current_user.id
      @highlight.verse_id = params["id"]
    end
    if params["color"] == 'x'
      @highlight.destroy
      @highlight = nil
    else
      @highlight.color = params["color"]
      @highlight.save
    end
    
    @verse = Verse.find(params["id"])
    
    respond_to do |format|  
      format.js 
    end

  end
  
  
end
