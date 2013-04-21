module MnModel
  class Record < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    belongs_to :note
    has_many :items

  end
end


      #self.class.class_eval do
      #  record.note.fields.each do |f|
      #    attr_accessor f.name.to_s
      #  end
      #end
