class ScheduledForecastsService < AppService
  def call
    remove_old_forecasts
    create_new_forecasts
    queue
  end

  def queue
    self.class.call
  end

  handle_asynchronously :queue, run_at: proc { 24.hours.from_now }

  private

  def remove_old_forecasts
    Forecast.where("date < ?", Date.current).destroy_all
  end

  def create_new_forecasts
    CreateForecastsService.call
  end
end