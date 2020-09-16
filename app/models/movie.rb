class Movie < ActiveRecord::Base
    scope :ratings_scope, ->  { distinct.order("rating").pluck("rating") }
    scope :with_ratings, ->(selected_ratings) { where(rating:selected_ratings) }
    scope :order_with_ratings, ->(selected_ratings,to_order) { where(rating:selected_ratings).order(to_order)}
end