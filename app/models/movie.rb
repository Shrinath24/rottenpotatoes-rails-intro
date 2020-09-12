class Movie < ActiveRecord::Base
    scope :ratings_scope, ->  { distinct.pluck("rating") }
    scope :with_ratings, ->(selected_ratings) { where(rating:selected_ratings) }
end