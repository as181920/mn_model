module MnModel
  class Note < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    has_many :fields
    has_many :records
    has_many :items, through: :fields

    validates_presence_of :name

    def create_record_with_date(attributes={})
      Record.create note_id: self.id
    end
  end
end
