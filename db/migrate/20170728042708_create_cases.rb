class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.integer  :service_request_id,         null: false
      t.string   :category,                   null: false
      t.string   :service_subtype
      t.string   :service_details
      t.string   :status,                     null: false
      t.string   :status_notes
      t.string   :agency

      t.string   :address
      t.st_point :location, geographic: true, null: false

      t.datetime :case_requested,             null: false
      t.datetime :case_updated

      t.string   :source

      t.timestamps
    end

    add_index :cases, :service_request_id, unique: true

    add_index :cases, :category
    add_index :cases, :status
    add_index :cases, :case_requested

    add_index :cases, :location, using: :gist
  end
end
