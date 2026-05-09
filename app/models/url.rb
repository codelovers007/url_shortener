class Url < ApplicationRecord
    before_create :generate_short_code

    validates :long_url, presence: true

    private

    def generate_short_code
        self.short_code = short_code_generate
    end

    def short_code_generate
        loop do
            code = SecureRandom.alphanumeric(6)
            break code unless Url.exists?(short_code: code)
        end
    end
end
