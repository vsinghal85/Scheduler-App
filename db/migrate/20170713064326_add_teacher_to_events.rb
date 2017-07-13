class AddTeacherToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :teacher, foreign_key: true
  end
end
