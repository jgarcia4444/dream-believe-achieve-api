require 'aws-sdk'

class User < ApplicationRecord
    has_secure_password

    has_one :notification_quote, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :daily_quotes, dependent: :destroy
    has_one :ota, dependent: :destroy

    validates :email, uniqueness: true
    validates :email, presence: true
    validates :username, uniqueness: true
    validates :username, presence: true

    def add_quote_to_daily_quotes(quote)
        new_daily_quote = DailyQuote.create(quote_id: quote.id, user_id: self.id)
        if !new_daily_quote
            render :json => {
                error: {
                    hasError: true,
                    message: "There was an error logging this quote to your account"
                }
            }
        end
    end

    def favorite_quotes
        self.favorites.map do |favorite|
            quote = Quote.find_by(id: favorite.quote_id)
            favorites_count = quote.favorites.count
            if quote
                {
                    id: quote.id,
                    author: quote.author,
                    quote: quote.quote,
                    favorites: favorites_count
                }
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: "There was an error finding a favorite quote."
                    }
                }
            end
        end
    end

    def send_verification_code
        sender = 'dream.believe.achieve.app@google.com'
        recipient = self.email
        code = self.ota.code
        subject = 'Verification Code'
        html_body = `<h1>Password Change Verification Code</h1>
        <p>Use the code below to verify your identity and change your password.</p>
        <h4>#{code}</h4>`
        text_body = 'Use the information in this email to continue the process of changing your password'

        encoding = 'UTF-8'

        ses = Aws::SES::Client.new(region: 'us-west-1')

        begin 
            ses.send_email(
                destination: {
                    to_address: [
                        recipient
                    ]
                },
                message: {
                    body: {
                        html: {
                            charset: encoding,
                            data: html_body
                        },
                        text: {
                            charset: encoding,
                            data: text_body
                        }
                    },
                    subject: {
                        charset: encoding,
                        data: subject
                    }
                },
                source: sender
            )
            true
        rescue
            Aws::SES:Errors:serviceError => error
            puts "Email not sent. Error message: #{error}"
            false
        end

    end
    

end