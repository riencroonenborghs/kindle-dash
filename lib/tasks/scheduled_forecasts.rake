namespace :scheduled_forecasts do
  desc "Start the ScheduledForecastsService"
  task start: :environment do
    ScheduledForecastsService.call
  end

  desc "Stop the ScheduledForecastsService"
  task stop: :environment do
    yaml = Delayed::PerformableMethod.new(ScheduledForecastsService.new, :queue_without_delay, []).to_yaml
    Delayed::Job.where(handler: yaml).map(&:destroy)
  end
end