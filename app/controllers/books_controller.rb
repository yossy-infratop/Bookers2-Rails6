class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_book, only: [:show, :edit, :update, :destroy]
  before_action :check_book_user, only: [:edit, :update, :destroy]
  impressionist :actions => [:show]

  def index
    @books = Book.includes(:user)
    @book = Book.new
  end

  def show
    @user = @book.user
    @new_book = Book.new
    @book_comment = BookComment.new
    # 詳細ページにアクセスするとPV数が1つ増える
    impressionist(@book, nil, unique: [:ip_address])
  end

  def new
    @book = Book.new(book_params)
    @books = RakutenWebService::Books::Book.search(title: @book.title)
  end

  def create
    @book = current_user.books.new(book_params)
    tag_list = params[:book][:tag_name].split(',')
    if params[:book][:isbn]
      select_book = RakutenWebService::Books::Book.search(isbn: params[:book][:isbn]).first
      @book.title = select_book.title
      @book.image_url = select_book.medium_image_url
      @book.item_url = select_book.item_url
      if @book.save
        @book.save_tag(tag_list)
        redirect_to book_path(@book.id), notice: "You have created book successfully"
      else
        @books = Book.all
        render :index
      end
    else
      redirect_to books_path
    end
  end

  def edit
  end

  def update
    tag_list = params[:book][:tag_name].split(',')
    if @book.update(book_params.except(:rate))
      # book.idに紐づいていたタグを@oldに入れる
      old_relations = BookTag.where(book_id: @book.id)
      # それらを取り出して削除
      old_relations.each do |relation|
        relation.delete
      end
      # 再度タグを保存
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
    @books = Book.sort(Book.includes(:user), params[:sort])
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