Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'secret', 'secret'
end
