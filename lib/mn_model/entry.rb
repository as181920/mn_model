module MnModel
  class Entry < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    belongs_to :note
    has_many :items

  end
end


