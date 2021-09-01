class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  has_one :host, through: :reservation

  validates :rating, presence: :true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :reservation_must_have_been_accepted
  validate :reservation_must_be_in_the_past

  def reservation_must_have_been_accepted
    if reservation && reservation.status != 'accepted'
      errors.add(:reservation, 'must have been accepted')
    end
  end

  def reservation_must_be_in_the_past
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, 'must be in the past')
    end
  end

end
