class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_book, only: [:show, :edit, :update, :destroy]
  before_action :check_book_user, only: [:edit, :update, :destroy]

  def index
    @books = Book.includes(:user)
    @book = Book.new
  end

  def show
    @user = @book.user
    @new_book = Book.new
    @book_comment = BookComment.new
  end

  def create
    @book = current_user.books.new(book_params)
    tag_list = params[:book][:tag_name].split(',')
    if @book.save
      @book.save_tag(tag_list)
      redirect_to book_path(@book.id), notice: "You have created book successfully"
    else
      @books = Book.all
      render :index
    end
  end

  def edit
  end

  def update
    tag_list = params[:book][:tag_name].split(',')
    if @book.update(book_params.except(:rate))
      @book.save_tag(tag_list)
      redirect_to book_path(@book.id), notice: "You have updated book successfully"
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  def sort
    if params[:sort] == "created_at"
      @books = Book.includes(:user).order(created_at: :desc)
    elsif params[:sort] == "rate"
      @books = Book.includes(:user).order(rate: :desc)
    else
      @books = Book.includes(:user)
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

  def ensure_book
    @book = Book.find(params[:id])
  end

  def check_book_user
    redirect_to books_path unless @book.user == current_user
  end

end
