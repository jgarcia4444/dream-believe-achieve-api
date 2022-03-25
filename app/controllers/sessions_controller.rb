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

end