class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices, id: :text do |t|
      t.text :phone_number
      t.text :carrier
      t.datetime :disabled_at, :default => nil

      t.timestamps
    end
  end
end
