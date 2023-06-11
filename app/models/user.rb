class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  has_many :relationships, foreign_key: :follower_id #フォローする側からのhas_many
  has_many :followings, through: :relationships, source: :follower #あるユーザーがフォローしている人を全員取ってくる あるユーザをフォローしてくれているを全員持ってくる
  
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :followed_id #フォローされる側からのhas_many
  has_many :followers, through: :reverse_of_relationships, source: :follower #あるユーザーをフォローしてくれている人を全員取ってくる
  
  def is_followed_by?(user) #あるユーザーがあるユーザーにフォローされているか否かを判定するメソッド
    reverse_of_relationships.find_by(follower_id: user.id).present?
  end
 
  def already_favorited?(book)
    self.favorites.exists?(book_id: book.id)
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}
  

  
  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [100, 100]).processed
  end
end
