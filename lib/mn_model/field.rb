module MnModel
  class Field < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    has_many :items
    belongs_to :note

    validates_presence_of :name
  end
end
