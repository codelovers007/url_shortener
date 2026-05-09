class TrackClickJob < ApplicationJob
  queue_as :default

  def perform(code)
    url = Url.find_by(short_code: code)
    url.increment!(:clicks) if url
    # Do something later
  end
end
