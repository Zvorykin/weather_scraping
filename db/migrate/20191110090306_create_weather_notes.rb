class CreateWeatherNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :weather_notes do |t|
      t.string :city, null: false
      t.integer :temp, null: false
      t.string :note

      t.timestamps
    end
  end
end
