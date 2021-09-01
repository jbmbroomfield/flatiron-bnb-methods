class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_and_host_cannot_be_the_same
  validate :listing_must_be_avaliable
  validate :checkout_must_be_after_checkin

  def guest_and_host_cannot_be_the_same
    if guest == host
      errors.add(:guest, "can't be the same as the host")
    end
  end

  def listing_must_be_avaliable
    if !listing.available?(checkin, checkout)
      errors.add(:listing, 'unavailable')
    end
  end

  def checkout_must_be_after_checkin
    if duration <= 0
      errors.add(:checkout, 'must be after checkin')
    end
  end

  def duration
    return 0 if !checkout || !checkin
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

end
