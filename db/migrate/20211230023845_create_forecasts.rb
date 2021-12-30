class CreateForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :forecasts do |t|
      t.date :date
      t.string :condition
      t.float :high_temp
      t.float :low_temp
      t.datetime :issued_at

      t.timestamps
    end
  end
end
