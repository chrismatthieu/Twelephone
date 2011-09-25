class BiblesController < ApplicationController
  # GET /bibles
  # GET /bibles.json
  def index
    @bibles = Bible.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bibles }
    end
  end

  # GET /bibles/1
  # GET /bibles/1.json
  def show
    @bible = Bible.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bible }
    end
  end

  # GET /bibles/new
  # GET /bibles/new.json
  def new
    @bible = Bible.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bible }
    end
  end

  # GET /bibles/1/edit
  def edit
    @bible = Bible.find(params[:id])
  end

  # POST /bibles
  # POST /bibles.json
  def create
    @bible = Bible.new(params[:bible])

    respond_to do |format|
      if @bible.save
        format.html { redirect_to @bible, notice: 'Bible was successfully created.' }
        format.json { render json: @bible, status: :created, location: @bible }
      else
        format.html { render action: "new" }
        format.json { render json: @bible.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bibles/1
  # PUT /bibles/1.json
  def update
    @bible = Bible.find(params[:id])

    respond_to do |format|
      if @bible.update_attributes(params[:bible])
        format.html { redirect_to @bible, notice: 'Bible was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bible.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bibles/1
  # DELETE /bibles/1.json
  def destroy
    @bible = Bible.find(params[:id])
    @bible.destroy

    respond_to do |format|
      format.html { redirect_to bibles_url }
      format.json { head :ok }
    end
  end
end
