class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :check_in, presence: true
  validates :check_out, presence: true
  validates :people, presence: true, numericality: { greater_than_or_equal_to: 1 }

  validate :check_in_must_be_today_or_later
  validate :check_out_must_be_after_check_in

  def stay_days
    return 0 if check_in.blank? || check_out.blank?

    check_out - check_in
  end

  def calculated_total_price
    return 0 if room.blank? || people.blank? || stay_days <= 0

    room.price * people * stay_days
  end

  private

  def check_in_must_be_today_or_later
    return if check_in.blank?

    errors.add(:check_in, "は本日以降の日付を選択してください") if check_in < Date.current
  end

  def check_out_must_be_after_check_in
    return if check_in.blank? || check_out.blank?

    errors.add(:check_out, "はチェックイン日より後の日付を選択してください") if check_out <= check_in
  end
end
