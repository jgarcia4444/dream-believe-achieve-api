class QuotesController < ApplicationController

    def destroy
        if params[:username]
            admin_username = params[:username]
            admin = Admin.find_by(username: username)
            if admin
                if params[:quote_info]
                    quote_info = params[:quote_info]
                    if quote_info[:id]
                        quote_id = quote_info[:id]
                        quote = Quote.find_by(id: quote_id)
                        if quote
                          if quote.destroy
                            render :json => {
                                error: {
                                    hasError: false
                                }
                            }
                          else 
                            render :json => {
                                error: {
                                    hasError: true,
                                    message: "There was an error deleting the quote."
                                }
                            }
                          end  
                        else
                            render :json => {
                                error: {
                                    hasError: true,
                                    message: "A quote was not found with the passed information."
                                }
                            }
                        end
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: "An id was not sent along with the quote info."
                            }
                        }
                    end
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: "Quote info was not sent to backend."
                        }
                    }
                end
            else 
                render :json => {
                    error: {
                        hasError: true,
                        message: "No admin user was found with passed username."
                    }
                }
            end
        else
            render :json => {
                error: {
                    hasError: true,
                    message: "A username was not passed to the backend."
                }
            }
        end
    end

    def index
        quotes = []
        if Quote.all.count > 0
            quotes = Quote.all
        end
        render :json => {
            error: {
                hasError: false
            },
            quotes: quotes
        }
    end

    def upload_quotes
        id = params[:id]
        if id 
            quotes = params[:quotes]
            if quotes
                if Admin.find_by(id: id)
                    persist_hash_quotes(quotes)
                    all_quotes = Quote.all
                    render :json => {
                        error: {
                            hasError: false
                        },
                        quotes: all_quotes
                    }
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: 'This is not a valid user id to upload quotes with.'
                        }
                    }
                end
            else 
                render :json => {
                    error: {
                        hasError: true,
                        message: 'No quotes were passed along in the body.'
                    }
                }
            end
        else 
            render :json => {
                error: {
                    hasError: true,
                    message: "User id was not passed along with URL."
                }
            }
        end
    end

    private 
        def persist_hash_quotes(hash_quotes)
            hash_quotes.each do |hash_quote|
                hash_author = hash_quote[:author]
                if !hash_author
                    hash_author = ""
                end
                quote = hash_quote[:quote]
                if !quote || quote == ""
                    render :json => {
                        error: {
                            hasError: true,
                            message: "Quote text must be sent along with a quote."
                        }
                    }
                end
                new_quote = Quote.create(author: hash_author, quote: quote)
                if !new_quote.valid?
                    render :json => {
                        error: {
                            hasError: true,
                            message: 'There was an error attempting to persist a quote.'
                        }
                    }
                end
            end
        end

end