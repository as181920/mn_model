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
        #if attributes[f.name].present?
        unless attributes[f.name].nil?
          item = entry.items.create field_id: f.id, content: attributes[f.name]
          entry_with_data["data"].merge!(f.name => item.content)
        end
      end

      return entry_with_data
    end

    def find_entry_with_data(options={})
      entry = Entry.find options["entry_id"]
      entry_with_data = {"data" => Hash.new}.merge! entry.serializable_hash

      fields.each do |f|
        item = Item.where(entry_id: entry.id, field_id: f.id).first
        #entry_with_data["data"].merge!(f.name => item.try(:content))
        entry_with_data["data"].merge!(f.name => item.content) if item
      end

      return entry_with_data
    end

    def all_entries_with_data(options={})
      #entries_with_date = get_entries_with_data_by_sql(entries)
      entries_with_date = get_entries_with_data_by_cal(items_with_field_name)
    end


    def items_with_field_name
      items.select("items.*, fields.name as field_name")
    end
    private

    def get_entries_with_data_by_sql(selected_entries)
      entries_with_date = selected_entries.collect do |entry|
        entry_with_data = {"data" => Hash.new}.merge! entry.serializable_hash

        fields.each do |f|
          item = Item.where(entry_id: entry.id, field_id: f.id).first
          #entry_with_data["data"].merge!(f.name => item.try(:content))
          entry_with_data["data"].merge!(f.name => item.content) if item
        end

        entry_with_data
      end
    end

    def get_entries_with_data_by_cal(items)
      entries_with_date = items.group_by{|e| e.entry_id.to_s}.map{|k, v| {"entry_id" => k, "data" => v.inject({}){|h, e| h.merge(e.field_name => e.content)}}}
    end
  end
end
