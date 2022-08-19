class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_many :group_users
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }
  validates :postal_code, presence: true
  validates :prefecture_code, presence: true
  validates :city, presence: true
  validates :street, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', "#{content}%")
    elsif method == 'backward'
      User.where('name LIKE ?', "%#{content}")
    else
      User.where('name LIKE ?', "%#{content}%")
    end
  end

  def following?(user)
    followings.include?(user)
  end

  def self.guest
    # find_or_create_by: データの検索と作成を自動的に判断して処理を行う
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      # SecureRandom.urlsafe_base64: ランダムな文字列を生成
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
      user.postal_code = "1066223"
      user.prefecture_code = "東京都"
      user.city = "港区六本木"
      user.street = "3-2-1"
      user.other_address = "住友不動産六本木グランドタワー23F"
      user.address = "東京都港区六本木3-2-1 住友不動産グランドタワー23F"
    end
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

end