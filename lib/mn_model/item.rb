module MnModel
  class Item < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS
    #self.table_name = "items"

    belongs_to :field
    belongs_to :entry

    validates_presence_of :field_id, :entry_id
  end
end
