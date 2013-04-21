module MnModel
  class Field < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    belongs_to :note
    has_many :items

    validates_presence_of :name
  end
end
