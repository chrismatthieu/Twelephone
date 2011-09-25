class CommentsController < ApplicationController
  def create
    
    @comment = Comment.new
    @comment.user_id = current_user.id
    @comment.verse_id = params["id"]
    @comment.comment = params["comment"]["comment"]
    @comment.save
        
    respond_to do |format|  
      format.js 
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
