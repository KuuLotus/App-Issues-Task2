class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  # 自分がフォローしているユーザーとの関連
  has_many :active_relationships, class_name: "Relationship",foreign_key: :follower_id,dependent: :destroy
  has_many :followers,through: :active_relationships,source: :followed
  
  # 自分がフォローされるユーザーとの関連
  has_many :passive_relationships, class_name: "Relationship",foreign_key: :followed_id,dependent: :destroy
  has_many :followeds,through: :passive_relationships,source: :follower

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction,length:{maximum:50}


  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def followed_by?(user)
    passive_relationships.find_by(follower_id: user.id).present?
  end
 
# 検索方法分岐 
  def self.looks(search,word)
    if search == "perfect_match"
      @user = User.where("name LIKE?","#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backword_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
  
end
