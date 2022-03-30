class SessionsController < ApplicationController
    def login
        login_info = params[:login_info]
        if login_info
            email = login_info[:email]
            if email
                user_logging_in = User.find_by(email: email)
                if user_logging_in
                    password = login_info[:password]
                    if password
                        authenticated_user = user_logging_in.authenticate(password)
                        if authenticated_user
                            render :json => {
                                error: {
                                    hasError: false
                                },
                                userInfo: {
                                    userId: authenticated_user.id,
                                    username: authenticated_user.username
                                }
                            }
                        else
                            render :json => {
                                error: {
                                    hasError: true,
                                    message: 'Incorrect Password.'
                                }
                            }
                        end
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: 'No password was given.'
                            }
                        }
                    end
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: "No user found with the given email."
                        }
                    }
                end
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: 'No email sent with login information'
                    }
                }
            end
        else 
            render :json => {
                error: {
                    hasError: true,
                    message: 'Error receiving information',
                }
            }
        end
    end

    def admin_login
        admin_info = params[:admin_info]
        if admin_info
            username = ""
            if admin_info[:username]
                username = admin_info[:username]
                if username == ""
                    render :json => {
                        error: {
                            hasError: true,
                            message: "Username can not be empty"
                        }
                    }
                end
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: "A username must be passed to login the admin."
                    }
                }
            end

            admin_user = Admin.find_by(username: username)
            if admin_user
                possible_password = ""
                if admin_info[:password]
                    possible_password = admin_info[:password]
                    if possible_password == ""
                        render :json => {
                            error: {
                                hasError: true,
                                message: "Password can not be left empty to login."
                            }
                        }
                    end
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: "A password must be passed to login the user."
                        }
                    }
                end

                if admin_user.authenticate(possible_password)
                    render :json => {
                        error: {
                            hasError: false
                        },
                        adminInfo: {
                            userId: admin_user.id,
                            username: admin_user.username
                        }
                    }
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: "Incorrect password."
                        }
                    }
                end
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: "No admin user was found with the username given."
                    }
                }
            end
        else
            render :json => {
                error: {
                    hasError: true,
                    message: "Information must be sent with admin_info."
                }
            }
        end
    end

end