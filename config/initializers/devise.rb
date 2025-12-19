Devise.setup do |config|
    config.omniauth :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], scope: 'read:user,user:email'
    config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
        scope: 'email, profile',
        prompt: 'select_account',
        image_aspect_ratio: 'square',
        image_size: 50
    }
end