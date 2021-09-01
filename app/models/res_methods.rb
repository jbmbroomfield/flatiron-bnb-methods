module ResMethods

    module InstanceMethods
        def res_per_listing
            return 0.0 if listings.count == 0
            1.0 * reservations.count / listings.count  
        end
    end

    module ClassMethods
        def highest_ratio_res_to_listings
            self.all.sort do |a, b|
                b.res_per_listing <=> a.res_per_listing
            end.first
        end

        def most_res
            self.all.sort do |a, b|
                b.reservations.count <=> a.reservations.count
            end.first
        end
    end

end