class CommentsController < ApplicationController
  def edit
    @comment = Comment.find(params[:id])

    prev_comment = session.delete :prev_comment
    if prev_comment
      diff = Diffy::Diff.new(prev_comment, @comment.comment)
      @comment_diff = diff.to_s(:html).gsub("\n",'') unless diff.string1 == diff.string2
    end
  end

  def create
    comment = params[:comment][:comment]
    plan_detail = PlanDetail.find(params[:plan_detail_id])

    @comment = plan_detail.comments.build(comment: comment, user_id: current_user.id)
    @comment.save

    render @comment
  end

  def update
    comment = Comment.find(params[:id])
    # store to use later
    session[:prev_comment] = comment.comment

    if comment.update_attributes(params[:comment])
      flash[:notice] = 'comment updated'
    else
      flash[:error] = "sorry, couldn't update your comment...undoing changes..."
    end

    redirect_to edit_comment_path(comment)
  end
end
