class FavoritesController < ApplicationController

    def add
        if params[:username]
            username = params[:username]
            user = User.find_by(username: username)
            if user
                if params[:favorite_quote_info]
                    favorite_quote_info = params[:favorite_quote_info]
                    if favorite_quote_info[:id]
                        quote_id = favorite_quote_info[:id]
                        quote = Quote.find_by(id: quote_id)
                        if quote
                            new_favorite = Favorite.create(user_id: user.id, quote_id: quote_id)
                            if new_favorite
                                quote_info = {
                                    id: quote_id,
                                    author: quote.author,
                                    quote: quote.quote
                                }
                                render :json => {
                                    error: {
                                        hasError: false,
                                    },
                                    newFavorite: quote_info
                                }
                            else
                                render :json => {
                                    error: {
                                        hasError: true,
                                        message: "An error occured saving this action.",
                                        errors: new_favorite.errors
                                    }
                                }
                            end
                        else
                            render :json => {
                                error: {
                                    hasError: true,
                                    message: "A quote was not found with the information given",
                                }
                            }
                        end
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: "No specific quote info received"
                            }
                        }
                    end
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: "No quote info received"
                        }
                    }
                end
            else 
                render :json => {
                    error: {
                        hasError: true,
                        message: "No user found with the given credentials"
                    }
                }
            end
        else
            render :json => {
                error: {
                    hasError: true,
                    message: "No user credentials were passed with the request."
                }
            }
        end
    end

end