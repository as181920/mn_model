module MnModel
  class Item < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS[DB_ENV]
    #self.table_name = "items"

    belongs_to :field
    belongs_to :entry

    validates_presence_of :field_id, :entry_id, :content

  end
end

