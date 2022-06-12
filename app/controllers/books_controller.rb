class BooksController < ApplicationController
  before_action :ensure_book, only: [:show, :edit, :update, :destroy]
  before_action :check_book_user, only: [:edit, :update, :destroy]

  def index
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    @new_book = Book.new
  end

  def show
    @new_book = Book.new
    @book_comment = BookComment.new
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully"
    else
      @books = Book.all
      @new_book = @book
      render :index
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully"
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_book
    @book = Book.find(params[:id])
  end

  def check_book_user
    redirect_to books_path unless @book.user == current_user
  end

end
