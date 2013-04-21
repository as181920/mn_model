module MnModel
  class Note < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    has_many :fields
    has_many :entries
    has_many :items, through: :fields

    validates_presence_of :name

    def create_entry_with_data(attributes={})
      entry_with_data = {}

      transaction do
        entry = Entry.create note_id: id
        entry_with_data.merge! entry.serializable_hash

        fields.each do |f|
          item = entry.items.create field_id: f.id, content: attributes[f.name]
          entry_with_data.merge!(f.name => item.content)
        end
      end

      return entry_with_data
    end
  end
end
