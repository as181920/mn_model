module MnModel
  class Item < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS
    #self.table_name = "items"

    belongs_to :field
    belongs_to :record

    validates_presence_of :field_id, :record_id
  end
end
