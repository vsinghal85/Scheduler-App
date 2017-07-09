class AddClientToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :client, foreign_key: true
  end
end
