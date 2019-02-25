class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.string :uri
      t.belongs_to :account, foreign_key: { on_delete: :cascade }
      t.belongs_to :status, foreign_key: { on_delete: :cascade }
      t.datetime :expires_at
      t.string :options, null: false, array: true, default: []
      t.boolean :multiple, null: false, default: false
      t.boolean :hide_totals, null: false, default: false

      t.timestamps
    end
  end
end
