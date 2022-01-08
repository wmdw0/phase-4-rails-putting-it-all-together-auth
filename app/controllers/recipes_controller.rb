class RecipesController < ApplicationController
    wrap_parameters false
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    before_action :authorize
  
    def create
        puts recipe_params
        userstuff =  User.find_by(id: session[:user_id])
        puts userstuff[:username]
        puts json: userstuff
        recipe = Recipe.create({title: recipe_params[:title], user: userstuff, instructions: recipe_params[:instructions], minutes_to_complete: recipe_params[:minutes_to_complete] })
        
        # recipe = Recipe.create(recipe_params)
        # session[:user_id] = user.id
        puts session[:user_id]
        puts recipe.errors.full_messages
        if recipe.valid?
          render json: recipe, status: :created
        else
          render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
        end
      end
    

    def show
      return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
      recipe = Recipe.find(params[:id])
      render json: recipe
    end
  
    def index        
      return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
      recipes = Recipe.all
      puts json: recipes
      
      # render json: articles
      # articles = Article.all.includes(:user)
      puts json: recipes.to_a
      render json: recipes
    end
    private

    def recipe_params
      params.permit(:title, :instructions, :minutes_to_complete)
    end

    def authorize
        puts session[:recipe_id]
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
      end
    
      def record_not_found
        render json: { error: "Recipe not found" }, status: :not_found
      end

end
