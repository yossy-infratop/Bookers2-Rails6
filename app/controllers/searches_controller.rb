class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'user'
      @records = User.search_for(@content, @method)
    elsif @model == 'book'
      @records = Book.search_for(@content, @method)
    else
      redirect_to request.referer
    end
  end

  def search_tag
    if params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @books = @tag.books.includes(:user)
    elsif params[:tag_name] != ""
      @tag = Tag.find_by(name: params[:tag_name])
      if @tag
        @books = @tag.books.includes(:user)
      else
        @tag = params[:tag_name]
      end
    else
      @tag = "タグを入力してください"
    end
  end

end