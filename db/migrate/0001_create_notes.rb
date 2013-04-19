class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :name, null: false
      t.text :description
      t.timestamps
    end

    create_table :fields do |t|
      t.references :note
      t.string :name, null: false
    end

    create_table :items do |t|
      t.references :field
      t.integer :record_id
      t.text :content
    end
  end
end
