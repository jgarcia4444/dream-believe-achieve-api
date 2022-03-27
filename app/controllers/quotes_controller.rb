class QuotesController < ApplicationController

    def upload_quotes
        id = params[:id]
        if id 
            quotes = params[:quotes]
            if quotes
                if User.find_by(id: id)
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
            json_quotes.each do |hash_quote|
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