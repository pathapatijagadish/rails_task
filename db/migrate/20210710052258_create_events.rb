class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.integer :event_type
      t.boolean :public
      t.integer :repository_id
      t.integer :actor_id

      t.timestamps
    end
  end
end
