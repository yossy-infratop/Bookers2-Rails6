class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  validates :rate, presence: true, length: { maximum: 5 }

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  # bookモデルでimpressionableを使用できるようになる : 9a : PV数
  is_impressionable

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', "#{content}%")
    elsif method == 'backward'
      Book.where('title LIKE ?', "%#{content}")
    else
      Book.where('title LIKE ?', "%#{content}%")
    end
  end

  def self.sort(books, sort)
    if sort == "created_at"
      books.order(created_at: :desc)
    elsif sort == "favorite"
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      books.sort {|a, b| b.favorites.where(created_at: from...to).size <=> a.favorites.where(created_at: from...to).size}
    elsif sort == "comment"
      books.sort {|a, b| b.book_comments.size <=> a.book_comments.size}
    elsif sort == "rate"
      books.includes(:user).order(rate: :desc)
    elsif sort == "impress"
      books.sort {|a, b| b.impressionist_count <=> a.impressionist_count}
    else
      books
    end
  end

  def save_tag(sent_tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

  #そのユーザがいいねをしているか判断
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end