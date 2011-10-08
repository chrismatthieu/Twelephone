class CommentsController < ApplicationController

  before_filter :current_user  

  can_edit_on_the_spot_in_tree

  def create
    
    @comment = Comment.new
    @comment.user_id = @current_user.id
    @comment.verse_id = params["id"]
    @comment.comment = params["comment"]["comment"]
    @comment.save
        
    respond_to do |format|  
      format.js
    end
    
  end
    
  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Note was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /bibles/1
  # DELETE /bibles/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      # format.html { redirect_to comments_url }
      format.js
    end
  end


end
