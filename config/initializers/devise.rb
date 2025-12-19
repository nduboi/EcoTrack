Devise.setup do |config|
    config.omniauth :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], scope: 'read:user,user:email'
    config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
        scope: 'email, profile',
        prompt: 'select_account',
        image_aspect_ratio: 'square',
        image_size: 50
    }
    config.navigational_formats = ['*/*', :html, :turbo_stream]
end

Rails.application.config.after_initialize do
  Devise.setup do |config|
    config.parent_controller = 'ApplicationController'
    config.warden do |manager|
      manager.failure_app = DeviseFailureApp
    end
  end
end
