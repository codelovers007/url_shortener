class UrlsController < ApplicationController
    def create 
        url = Url.find_or_create_by(long_url: params[:long_url])
        render json: { short_url: short_url(url.short_code) }
    end

    def show

        # url = Url.find_by(short_code: params[:code])

        long_url = Rails.cache.fetch("url:#{params[:code]}", expires_in: 12.hours) do
            Url.find_by(short_code: params[:code])&.long_url
        end

        if long_url
            TrackClickJob.perform_later(params[:code])
            redirect_to long_url, allow_other_host: true
        else
            render json: { error: "Not Found" }, status: 404
        end
    end

    private

    def short_url(code)
        "#{request.base_url}/#{code}"
    end
end
