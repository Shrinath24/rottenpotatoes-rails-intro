class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@all_ratings = Movie.distinct.pluck(:rating)
   if params[:sort].nil?
      params[:sort] = session[:sort]
   end
   if params[:ratings].nil?
      params[:ratings] = session[:ratings]
   end
    sort = params[:sort]
    session[:sort] = params[:sort]
    if 'title' == sort
       @movies = Movie.order(:title)
    elsif 'date' == sort
       @movies = Movie.order(:release_date)
    end
        rating_param = params[:ratings]
        session[:ratings] = params[:ratings]
        if !rating_param.nil?
          selected_ratings = rating_param.keys
          @movies = Movie.with_ratings(selected_ratings)
        else
          @movies = Movie.all
        end
    @all_ratings = Movie.ratings_scope
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
