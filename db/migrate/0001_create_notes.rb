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
      t.timestamps
    end

    create_table :entries do |t|
      t.references :note
      t.timestamps
    end

    create_table :items do |t|
      t.references :field
      t.references :entry
      t.text :content
      t.timestamps

      t.index([:field_id, :entry_id], :unique => true)
    end
  end
end
