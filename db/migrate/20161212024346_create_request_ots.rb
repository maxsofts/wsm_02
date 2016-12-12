class CreateRequestOts < ActiveRecord::Migration[5.0]
  def change
    create_table :request_ots do |t|
      t.time :from_time
      t.time :end_time
      t.string :reason
      t.integer :status
      t.references :user, foreign_key: true
      t.integer :approve_group

      t.timestamps
    end
  end
end
