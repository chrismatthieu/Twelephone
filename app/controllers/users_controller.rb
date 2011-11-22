class UsersController < ApplicationController

  before_filter :login_required, :except => [:new, :create]
  before_filter :admin_required, :only => [:index, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
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
      # Find contacts
    end 
    
    @username = params[:user]
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end
  
  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  # GET /users/1/edit
  def edit
    if @current_user.admin
      if params[:id] and isNumeric(params[:id])
        @user = User.find(params[:id])
      else
        @user = User.find_by_username(params[:id])
      end
    else
      @user = User.find(@current_user.id)
    end
  end

  # GET /users/1/edit
  def password
    # if @current_user.admin
    #   if params[:id] and isNumeric(params[:id])
    #     @user = User.find(params[:id])
    #   else
    #     @user = User.find_by_username(params[:id])
    #   end
    # else
      @user = User.find(@current_user.id)
    # end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        
        # Send welcome email
        @message = "Welcome to Twlephone!"
        Notifier.contact(@user.email, "chris@twelephone.com", @message).deliver
        
        session[:user_id] = @user.id
        
        format.html { redirect_to "/", :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render action: "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if params[:id] and isNumeric(params[:id])
      @user = User.find(params[:id])
    else
      @user = User.find_by_username(params[:id])
    end
    

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
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
