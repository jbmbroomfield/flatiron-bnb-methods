class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  include ResMethods::InstanceMethods
  extend ResMethods::ClassMethods

  def neighborhood_openings(checkin, checkout)
    Listing.openings(checkin, checkout, listings)
  end

end
