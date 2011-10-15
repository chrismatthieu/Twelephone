class IssuesController < ApplicationController

  before_filter :current_user  

  # GET /issues
  # GET /issues.json
  def index
    # @issues = Issue.find(:all, :order => 'updated_at DESC')
    @issues = Issue.paginate(:order => 'updated_at DESC', 
    :per_page => 10,
    :page => params[:page])
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @issue = Issue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/new
  # GET /issues/new.json
  def new
    @issue = Issue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/1/edit
  def edit
    @issue = Issue.find(params[:id])
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(params[:issue])
    @issue.user_id = @current_user.id

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render json: @issue, status: :created, location: @issue }
      else
        format.html { render action: "new" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /issues/1
  # PUT /issues/1.json
  def update
    @issue = Issue.find(params[:id])

    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :ok }
    end
  end
  
  def search
    if params[:page].nil?
      if params[:search].nil? 
        session[:searchterm] = params[:id]
      else
        session[:searchterm] = params[:search][:searchtext]
      end
    end
    
    if request.url.index('localhost')
       @issuecount = Issue.count(:all, :conditions => ["title LIKE ? or description LIKE ?", '%' + session[:searchterm] + '%', '%' + session[:searchterm] + '%'])

       @issues = Issue.paginate(:conditions => ["title LIKE ? or description LIKE ?", '%' + session[:searchterm] + '%', '%' + session[:searchterm] + '%'], 
       :per_page => 10,
       :page => params[:page])

     else
       @issuecount = Issue.count(:all, :conditions => ["title ILIKE ? or description ILIKE ?", '%' + session[:searchterm] + '%', '%' + session[:searchterm] + '%'])

       @issues = Issue.paginate(:conditions => ["title ILIKE ? or description ILIKE ?", '%' + session[:searchterm] + '%', '%' + session[:searchterm] + '%'], 
       :per_page => 10,
       :page => params[:page])

    end
  end
  
  
end
