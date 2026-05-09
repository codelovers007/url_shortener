class ApplicationController < ActionController::API
  RATE_LIMIT = 100
  PERIOD = 1.minutes

  def check_rate_limit
    key = "rate-limit:#{request.ip}"

    current_count = Rails.cache.read(key).to_i

    if current_count >= RATE_LIMIT
      response.headers['X-RateLimit-Limit'] = RATE_LIMIT.to_s
      response.headers['X-RateLimit-Remaining'] = '0'
      response.headers['Retry-After'] = '60'

      render json: { error: 'Too many requests' }, status: 429
      
      return
    end

    Rails.cache.write(key, current_count + 1, expires_in: PERIOD)

    response.headers['X-RateLimit-Limit'] = RATE_LIMIT.to_s
    response.headers['X-RateLimit-Remaining'] = (RATE_LIMIT - current_count - 1).to_s
  end
end
