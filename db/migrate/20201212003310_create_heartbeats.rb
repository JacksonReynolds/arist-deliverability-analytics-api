class CreateHeartbeats < ActiveRecord::Migration[6.0]
  def change
    create_table :heartbeats, id: :text do |t|
      t.integer :device_id
      t.datetime :created_at
    end
  end
end