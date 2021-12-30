class CreateForecastDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :forecast_details do |t|
      t.references :forecast, null: false, foreign_key: true
      t.float :high_temp
      t.float :low_temp
      t.datetime :sunrise
      t.datetime :sunset
      t.string :details
      t.float :rain_1mm
      t.float :rain_10mm

      t.timestamps
    end
  end
end
