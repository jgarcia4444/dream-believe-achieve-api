class UsersController < ApplicationController
    def create
        new_user = User.create(user_params)
        if new_user.valid?
            render :json => {
                error: {
                    hasError: false
                },
                userInfo: {
                    userId: new_user.id,
                    username: new_user.username,
                    email: new_user.email
                }
            }
        else 
            render :json => {
                error: {
                    hasError: true,
                    message: "Errors while creating a user account",
                    errors: new_user.errors
                }
            }
        end
    end

    def show
        user_id = params[:id]
        if user_id
            user = User.find_by(id: user_id)
            if user
                favorite_quotes = user.favorites.map {|favorite| Quote.find_by(id: favorite.quote_id)}
                render :json => {
                    error: {
                        hasError: false
                    },
                    userInfo: {
                        userId: user.id,
                        username: username,
                        favorites: favorite_quotes
                    }
                }
            else 
                render :json => {
                    error: {
                        hasError: true,
                        message: "No user found with the given id."
                    }
                }
            end
        else 
            render :json => {
                error: {
                    hasError: true,
                    message: 'No user id was sent along with the users show route.'
                }
            }
        end
    end

    

    private
        def user_params
            params.require(:user).permit(:email, :username, :password)
        end
end