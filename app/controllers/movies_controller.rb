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
  
   if params[:sort].nil?
      params[:sort] = session[:sort]
   end
   if params[:ratings].nil?
      params[:ratings] = session[:ratings]
   end
    sort = params[:sort]
    

        rating_param = params[:ratings]

        if !rating_param.nil?
          selected_ratings = rating_param.keys
          @movies = Movie.with_ratings(selected_ratings)
        else
          @movies = Movie.all
        end
    if 'title' == sort
      if !rating_param.nil?
        @movies = Movie.order_with_ratings(selected_ratings,:title)
      else
        @movies = Movie.order(@all)
      end
    elsif 'date' == sort
      if !rating_param.nil?
       @movies = Movie.order_with_ratings(selected_ratings,:release_date)
      else
        @movies = Movie.order(@all)
      end
    end
    @all_ratings = Movie.ratings_scope
  session[:sort] = params[:sort]
  session[:ratings] = params[:ratings]
  @redirect_params = params
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path({:sort => session[:sort], :rating => session[:ratings]})
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
    redirect_to movies_path({:sort => session[:sort], :rating => session[:ratings]})
  end
end
