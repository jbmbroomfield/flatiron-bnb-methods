class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: :true
  validates :title, presence: :true
  validates :description, presence: :true
  validates :price, presence: :true
  validates :neighborhood, presence: :true

  before_create :convert_user_to_host
  before_destroy :check_to_remove_host_status
  
  def available?(checkin, checkout)
    return false if !checkin || !checkout
    checkin = Date.parse(checkin) rescue checkin
    checkout = Date.parse(checkout) rescue checkout

    reservations.each do |reservation|
      return false if checkin.between?(reservation.checkin, reservation.checkout)
      return false if checkout.between?(reservation.checkin, reservation.checkout)
    end
    true
  end

  def convert_user_to_host
    host.update(host: true)
  end

  def check_to_remove_host_status
    host.update(host: false) if host.listings.count <= 1
  end

  def average_review_rating
    reviews.reduce(0.0) { |sum, review| sum + review.rating } / reviews.count
  end

  def self.openings(checkin, checkout, listings = self.all)
    listings.filter do |listing|
      listing.available?(checkin, checkout)
    end
  end

end
