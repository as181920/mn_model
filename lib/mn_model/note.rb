module MnModel
  class Note < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    has_many :fields
    has_many :entries
    has_many :items, through: :fields

    validates_presence_of :name

    def create_entry_with_data(attributes={})
      entry_with_data = {"data" => Hash.new}

      #transaction do
      #end
      entry = Entry.create note_id: id
      entry_with_data.merge! entry.serializable_hash

      fields.each do |f|
        item = entry.items.create field_id: f.id, content: attributes[f.name]
        entry_with_data["data"].merge!(f.name => item.content)
      end

      return entry_with_data
    end

    def find_entry_with_data(options={})
      entry = Entry.find options["entry_id"]
      entry_with_data = {"data" => Hash.new}.merge! entry.serializable_hash

      fields.each do |f|
        item = Item.where(entry_id: entry.id, field_id: f.id).first
        entry_with_data["data"].merge!(f.name => item.try(:content))
      end

      return entry_with_data
    end

    def entries_with_data(options={})
      entries_with_date = entries.collect do |entry|
        entry_with_data = {"data" => Hash.new}.merge! entry.serializable_hash

        fields.each do |f|
          item = Item.where(entry_id: entry.id, field_id: f.id).first
          entry_with_data["data"].merge!(f.name => item.try(:content))
        end

        entry_with_data
      end
    end

    private
  end
end
