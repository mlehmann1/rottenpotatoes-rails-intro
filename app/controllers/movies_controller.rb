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
    @movies = Movie.order(params[:sort_by])
    
    if(!params.has_key?(:sort_by) && !params.has_key?(:ratings))
      if(session.has_key?(:sort_by) || session.has_key?(:ratings))
        redirect_to movies_path(:sort_by=>session[:sort_by], :ratings=>session[:ratings])
      end
    end
    
    if params[:sort_by]
      @sort_by = params[:sort_by]
      session[:sort_by] = @sort_by
    elsif session[:sort_by]
      @sort_by = session[:sort_by]
      params[:sort_by] = @sort_by
    else
      session[:sort_by] = []
    end
    
    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    elsif session[:ratings]
      @ratings = session[:ratings]
      params[:ratings] = @ratings
    else
      session[:rating] = []
    end
    
    @movies = Movie.where(:rating => @ratings.keys).order(@sort_by)
    @sort_column = @sort_by
    @all_ratings = Movie.get_ratings
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
