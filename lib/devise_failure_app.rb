class DeviseFailureApp < Devise::FailureApp
  def respond
    if request.format == :turbo_stream
      redirect
    else
      super
    end
  end

  def skip_format?
    %w(html turbo_stream */*).include? request.format.to_s
  end
end