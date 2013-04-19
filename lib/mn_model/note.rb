module MnModel
  class Note < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    has_many :fields
    has_many :items, through: :fields

    validates_presence_of :name

    def records
      []
    end
  end
end
