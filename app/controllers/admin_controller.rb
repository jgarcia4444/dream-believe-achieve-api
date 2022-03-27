
class AdminController < ApplicationController
    def create
        creating_admin = params[:creating_admin]
        if creating_admin
            new_admin = Admin.create(admin_params)
            if new_admin.valid?
                render :json => {
                    error: {
                        hasError: false
                    },
                    new_admin: {
                        username: new_admin.username
                    }
                }
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: "There was an error creating the new admin user.",
                        errors: new_admin.errors
                    }
                }
            end
        else
            render :json => {
                error: {
                    hasError: true,
                    message: "Information for a valid creating admin must be sent along to create a new admin user."
                }
            }
        end
    end

    private 
        def admin_params
            params.require(:new_admin).permit(:username, :password)
        end

end