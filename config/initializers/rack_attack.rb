class Rack::Attack
  # Limit request per IP
  throttle('req/ip', limit: 5, period: 1.minutes) do |req|
    req.ip
  end
end