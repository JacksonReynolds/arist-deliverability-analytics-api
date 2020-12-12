class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports, id: :uuid do |t|
      t.text :sender
      t.text :message
      t.uuid :device_id

      t.timestamps
    end
  end
end
