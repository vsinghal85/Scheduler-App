class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :text
      t.string :rec_type
      t.integer :event_length
      t.integer :event_pid

      t.timestamps
    end
  end
end
