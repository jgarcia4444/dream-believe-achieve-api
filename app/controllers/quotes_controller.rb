class QuotesController < ApplicationController

    def destroy
        if params[:username]
            admin_username = params[:username]
            admin = Admin.find_by(username: admin_username)
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

    def daily_quote
        user_info = params[:user_info]
        if user_info 
            if user_info[:username]
                username = user_info[:username]
                user = User.find_by(username: username)
                if user
                    if user_info[:quote_of_the_day_date]
                        quote_of_the_day_date = user_info[:quote_of_the_day_date]
                        if check_for_day_since_quote(quote_of_the_day_date)
                            random_quote = get_random_quote
                            if random_quote
                                render :json => {
                                    error: {
                                        hasError: false
                                    },
                                    dailyQuote: {
                                        quoteOfTheDay: random_quote
                                    }
                                }
                            else
                                render :json => {
                                    error: {
                                        hasError: true,
                                        message: "There was an error getting a random quote."
                                    }
                                }
                            end
                        else
                            render :json => {
                                error: {
                                    haError: true,
                                    message: "Quote of the day can only be refreshed every 24 hours."
                                }
                            }
                        end
                    else
                        render :json => {
                            error: {
                                hasError: true,
                                message: "The date of the previous quote of the day date was not sent."
                            }
                        }
                    end
                else
                    render :json => {
                        error: {
                            hasError: true,
                            message: "No user was found with the given username."
                        }
                    }
                end
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: "A username must be passed along to find the quote of the day."
                    }
                }
            end
        else 
            render :json => {
                error: {
                    hasError: true,
                    message: "User Information must be sent to get a daily quote."
                }
            }
        end
    end

    private 

        def get_random_quote
            random_quote_index = rand Quote.all.count
            index_rounded = random_quote_index.floor
            Quote.all[index_rounded]
        end

        def check_for_day_since_quote(quote_date_string)
            quote_time = Time.parse(quote_date_string)
            todays_time = Time.now
            quote_date = quote_time.to_date
            todays_date = todays_time.to_date
            hour_difference = quote_time.hour - todays_time.hour
            if (quote_date.cwday != todays_date && hour_difference == 0)
                true 
            else
                false
            end
        end

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