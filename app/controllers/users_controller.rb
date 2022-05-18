
class UsersController < ApplicationController
    def create
        puts "User create action triggered!!!!!!!!!!!"
        if params[:user]
            user_info = params[:user]
            if user_info[:email] || user_info[:email] != ""
                email = user_info[:email].downcase
                if user_info[:username] || user_info[:username] != ""
                    username = user_info[:username].downcase
                    if user_info[:password] || user_info[:password] != ""
                        password = user_info[:password]
                        new_user = User.create(username: username, email: email, password: password)
                        if new_user.valid?
                            top_ten_quotes = Favorite.find_top_ten
                            render :json => {
                                error: {
                                    hasError: false
                                },
                                userInfo: {
                                    userId: new_user.id,
                                    username: new_user.username,
                                    email: new_user.email
                                },
                                topTenQuotes: top_ten_quotes,
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
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: 'A password was not provided'
                            }
                        }
                    end
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: 'A username was not provided'
                        }
                    }
                end
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: 'An email was not provided'
                    }
                }
            end
        else 
            render :json => {
                error: {
                    hasError: true,
                    message: "No user info was passed along to backend."
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

    def favorites
        if params[:username]
            username = params[:username]
            user = User.find_by(username: username)
            if user
                user_favorite_quotes = user.favorite_quotes
                top_ten_quotes = Favorite.find_top_ten
                render :json => {
                    error: {
                        hasError: false,
                    },
                    favoriteQuotes: user_favorite_quotes,
                    topTenQuotes: top_ten_quotes,
                }
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: "Unable to find a user with passed credentials."
                    }
                }
            end
        else
            render :json => {
                error: {
                    hasError: true,
                    message: "Server Error."
                }
            }
        end
    end

    def send_code
        if params[:email]
            email = params[:email]
            user = User.find_by(email: email)
            if user
                code = generate_random_code
                puts code
                if user.ota
                    user.ota.update(code: code)
                    if user.ota.valid?
                        puts "OTA code valid code:#{ota.code}"
                        # Send code with mailer
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: "There was an error creating the code for the user."
                            }
                        }
                    end
                else
                    new_ota = Ota.create(code: code, user_id: user.id)
                    if new_ota.valid?
                        puts "OTA code valid code:#{ota.code}"
                        # Send code with mailer
                        
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: "There was an error creating the code for the user."
                            }
                        }
                    end
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
                    message: "An email must be sent with this request."
                }
            }
        end
    end

    private
        def generate_random_code
            code_string = ""
            6.times do |i|
                num = rand(9) + 1
                code_string += num.to_s
            end
            code_string
        end
    
end