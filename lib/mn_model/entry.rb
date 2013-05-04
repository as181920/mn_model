module MnModel
  class Entry < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    belongs_to :note
    has_many :items

    class << self
      def find_with_data(id, options={})
        entry = Entry.find id
        entry_with_data = {"data" => Hash.new}.merge! entry.serializable_hash

        entry.note.fields.each do |f|
          item = Item.find_by entry_id: entry.id, field_id: f.id
          #entry_with_data["data"].merge!(f.name => item.try(:content))
          entry_with_data["data"].merge!(f.name => item.content) if item
        end

        return entry_with_data
      end

      def all_data(options={})
        note = Note.find options[:note_id]
        items_with_field_name = note.items.select("items.*, fields.name as field_name")
        entries_with_date = items_with_field_name.group_by{|e| e.entry_id}.map do |k, v|
          {"note_id" => note.id, "entry_id" => k, "data" => v.inject({}){|h, e| h.merge(e.field_name => e.content)}}
        end
      end

      def create_with_data(attributes={})
        entry_with_data = {"data" => Hash.new}

        #transaction do
        #end
        entry = Entry.create
        entry_with_data.merge! entry.serializable_hash

        entry.note.fields.each do |f|
          #if attributes[f.name].present?
          unless attributes[f.name].nil?
            item = entry.items.create field_id: f.id, content: attributes[f.name]
            entry_with_data["data"].merge!(f.name => item.content)
          end
        end

        return entry_with_data
      end

      def update_with_data(id, attributes={})
        entry_with_data = {"data" => Hash.new}

        entry = Entry.find_by id: id
        entry_with_data.merge! entry.serializable_hash

        entry.items.each do |it|
          field_name = it.field.name
          it.update_attributes(content: attributes[field_name]) unless attributes[field_name].nil?
          entry_with_data["data"].merge!(field_name => it.content)
        end

        return entry_with_data
      end
    end

    def with_data
      with_data = {"data" => Hash.new}.merge! self.serializable_hash
      note.fields.each do |f|
        item = Item.find_by entry_id: id, field_id: f.id
        with_data["data"].merge!(f.name => item.content) if item
      end

      return with_data
    end

    def update_with_data(attributes={})
      entry_with_data = self.serializable_hash.merge("data" => Hash.new)

      items.each do |it|
        field_name = it.field.name
        it.update_attributes(content: attributes[field_name]) unless attributes[field_name].nil?
        entry_with_data["data"].merge!(field_name => it.content)
      end

      return entry_with_data
    end

  end
end


