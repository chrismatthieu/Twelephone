class UsersController < ApplicationController

  before_filter :login_required, :except => [:new, :create]
  before_filter :admin_required, :only => [:index, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if params[:id] and isNumeric(params[:id])
      @user = User.find(params[:id])
    else
      @user = User.find_by_username(params[:user])
    end
    
    if @user
      @follow = Follow.find(:first, :conditions => ["user_id = ? and follow_id = ?", @current_user.id, @user.id])

      # @activities = User.comments.paginate :page => params[:page], :per_page => 3
      @activities = Comment.paginate :page => params[:page], :conditions => ['user_id = ?', @user.id], :order => 'updated_at DESC'
    end 
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  
  def feed
     # ITS GRABBING THE WRONG USERID 
     # @activities = Comment.find_by_sql("SELECT * FROM comments, follows where (comments.user_id = follows.follow_id or comments.user_id = #{@current_user.id}) and (follows.user_id = #{@current_user.id}) order by comments.updated_at DESC")
     
     
     @activities = Comment.paginate :page => params[:page], :per_page => 10, :select => "comments.user_id, comments.verse_id, comments.comment, comments.color",  
     :conditions => ["(follows.user_id = #{@current_user.id})"],
     :joins => "left outer join follows on comments.user_id = follows.follow_id or comments.user_id = #{@current_user.id}",
     :order => 'comments.updated_at DESC'
          
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  # GET /users/1/edit
  def edit
    if @current_user.admin
      @user = User.find(params[:id])
    else
      @user = User.find(@current_user.id)
    end
  end

  # GET /users/1/edit
  def password
    if @current_user.admin
      @user = User.find(params[:id])
    else
      @user = User.find(@current_user.id)
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        
        # Send welcome email
        @message = "Welcome to Gospelr!"
        Notifier.contact(@user.email, "chris@gospelr.com", @message).deliver
        
        session[:user_id] = @user.id
        
        format.html { redirect_to "/", notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end
