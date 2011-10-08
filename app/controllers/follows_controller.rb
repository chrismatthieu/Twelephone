class FollowsController < ApplicationController

  before_filter :current_user  

  # GET /follows
  # GET /follows.json
  def index
    
    if params[:user] and isNumeric(params[:user])
      @user = User.find(params[:user])
    else
      @user = User.find_by_username(params[:user])
    end

    if @user    
      if params[:view] == 'following'
        # Following
        @follows = Follow.paginate :page => params[:page], :conditions => ["user_id = ?", @user.id]
      else
        # Followers
        @follows = Follow.paginate :page => params[:page], :conditions => ["follow_id = ?", @user.id]
      end 
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @follows }
    end
  end

  # GET /follows/1
  # GET /follows/1.json
  def show
    @follow = Follow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @follow }
    end
  end

  # GET /follows/new
  # GET /follows/new.json
  def new
    @follow = Follow.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @follow }
    end
  end

  # GET /follows/1/edit
  def edit
    @follow = Follow.find(params[:id])
  end

  # POST /follows
  # POST /follows.json
  def create
    
    # Follow or Unfollow based on status param in AJAX
    
    if params[:status] == "follow"
      @follow = Follow.new(params[:follow])    
      @follow.user_id = @current_user.id
      @follow.follow_id = params[:id]    
      @follow.save      
    else # unfollow
      @follow = Follow.find(:first, :conditions => ["user_id = ? and follow_id = ?", @current_user.id, params[:id]])
      if @follow
        @follow.destroy
      end      
    end
    @user = User.find(params[:id])
    
    if params[:status] == "follow"
      # Send welcome email
      @message = "Hi #{@current_user.username.capitalize}, \n\n#{@user.username.capitalize} is now following you on Gospelr! You can follow them back by clicking on this link: http://gospelr.com/#{@user.username} \n\nGod Bless, \nGospelr"
      Notifier.contact(@current_user.email, "chris@gospelr.com", @message).deliver
    end
    
    respond_to do |format|  
      format.js 
    end
    
  end

  # PUT /follows/1
  # PUT /follows/1.json
  def update
    @follow = Follow.find(params[:id])

    respond_to do |format|
      if @follow.update_attributes(params[:follow])
        format.html { redirect_to @follow, notice: 'Follow was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy

    respond_to do |format|
      format.html { redirect_to follows_url }
      format.json { head :ok }
    end
  end
end
