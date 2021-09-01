class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(checkin, checkout)
    Listing.openings(checkin, checkout, listings)
  end

  def res_per_listing
    1.0 * reservations.count / listings.count  
  end

  def self.highest_ratio_res_to_listings
    self.all.sort do |a, b|
      b.res_per_listing <=> a.res_per_listing
    end.first
  end

  def self.most_res
    self.all.sort do |a, b|
      b.reservations.count <=> a.reservations.count
    end.first
  end


end

