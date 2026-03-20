class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # roomモデルのリレーション
  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy

  # 画像アップロード用
  has_one_attached :image
end
