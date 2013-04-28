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
    end

    def with_data
      with_data = {"data" => Hash.new}.merge! self.serializable_hash
      note.fields.each do |f|
        item = Item.find_by entry_id: id, field_id: f.id
        with_data["data"].merge!(f.name => item.content) if item
      end

      return with_data
    end


  end
end


