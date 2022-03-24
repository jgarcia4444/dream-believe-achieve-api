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


    private
        def user_params
            params.require(:user).permit(:email, :username, :password)
        end
end