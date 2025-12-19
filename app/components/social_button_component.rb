class SocialButtonComponent < ViewComponent::Base
  def initialize(provider:, path:)
    @provider = provider
    @path = path
  end

  def brand_class
    case @provider.to_sym
    when :github then "bg-black text-white"
    when :google then "bg-white text-gray-700 border"
    else "btn-primary"
    end
  end
end