class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy

  validates :name, presence: true                                                  # 施設名は必須
  validates :description, presence: true                                           # 施設詳細は必須
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }  # 宿泊料金は必須、かつ1円以上
  validates :address, presence: true                                               # 住所は必須

  # 画像アップロード用
  has_one_attached :image
end
