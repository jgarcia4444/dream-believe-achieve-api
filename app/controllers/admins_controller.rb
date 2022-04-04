
class AdminsController < ApplicationController
    def create
        if params[:admin_create]
            admin_create = params[:admin_create]
            creating_admin_info = admin_create[:creating_admin]
            route_admin_id = params[:admin_id]
            if creating_admin_info
                creating_admin_username = ""
                if creating_admin_info[:username]
                    creating_admin_username = creating_admin_info[:username]
                end
                creating_admin_equals_route_admin(route_admin_id, creating_admin_username)
                creating_admin = Admin.find_by(username: creating_admin_username)
                if creating_admin
                    creating_admin_password = ""
                    if creating_admin_info[:password]
                        creating_admin_password = creating_admin_info[:password]
                    end
                    if creating_admin.authenticate(creating_admin_password)
                        new_admin_info = admin_create[:new_admin]
                        if new_admin_info
                            new_admin_username = new_admin_info[:username]
                            if new_admin_username == ""
                                render :json => {
                                    error: {
                                        hasError: true,
                                        message: "Username can not be left blank."
                                    }
                                }
                                return
                            end

                            new_admin_password = new_admin_info[:password]
                            if new_admin_password == ""
                                render :json => {
                                    error: {
                                        hasError: true,
                                        message: "Password can not be left blank."
                                    }
                                }
                                return
                            end
                            new_admin = Admin.create(username: new_admin_username, password: new_admin_password)
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
                                    message: "New admin info was not sent along."
                                }
                            }
                        end
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: "Incorrect Password for the creating admin."
                            }
                        }
                    end
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: "No admin found with the given username"
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
        else
            render :json => {
                error: {
                    hasError: true,
                    message: "Data is being sent improperly."
                }
            }
        end
    end

    private 
        def creating_admin_equals_route_admin(route_id, creating_username)
            route_admin = Admin.find_by(id: route_id)
            if route_admin
                creating_admin = Admin.find_by(username: creating_username)
                if creating_admin
                    if route_admin.username === creating_admin.username
                        true
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: "The signed in admin and creating admin must be the same."
                            }
                        }
                    end
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: "No admin was found with the passed username."
                        }
                    }
                end
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: "Route id is not a valid admin id."
                    }
                }
            end
        end

end