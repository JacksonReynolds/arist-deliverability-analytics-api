class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports, id: :text do |t|
      t.text :sender
      t.text :message
      t.integer :device_id

      t.timestamps
    end
  end
end
