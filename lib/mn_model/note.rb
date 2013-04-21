module MnModel
  class Note < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    has_many :fields
    has_many :records
    has_many :items, through: :fields

    validates_presence_of :name

    def create_record_with_date(attributes={})
      record_with_data = {}

      transaction do
        record = Record.create note_id: id
        record_with_data.merge! record.serializable_hash

        fields.each do |f|
          item = record.items.create field_id: f.id, content: attributes[f.name]
          record_with_data.merge!(f.name => item.content)
        end
      end

      return record_with_data
    end
  end
end
