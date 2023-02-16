class GenerateScreenshotJob
  include Sidekiq::Job

  def perform(*args)
    generate_screenshot
  end

  private

  def generate_screenshot
    system(command)
  end

  def command
    "#{ENV.fetch('WKHTMLTOIMAGE')} #{options} \"#{ENV.fetch('URL')}\" \"#{output}\"; convert \"#{output}\" -colorspace Gray \"#{output}\""
  end

  def options
    "--width 600 --height 800 --user-style-sheet \"#{css}\""
  end

  def css
    Rails.root.join("public", *ActionController::Base.helpers.asset_path("application.css").split("/"))
  end

  def output
    Rails.root.join("public", "screenshot.png")
  end
end
