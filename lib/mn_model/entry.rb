module MnModel
  class Entry < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    belongs_to :note
    has_many :items

    class << self
    end

    def with_data
      with_data = {"data" => Hash.new}.merge! self.serializable_hash
      note.fields.each do |f|
        item = Item.where(entry_id: id, field_id: f.id).first
        with_data["data"].merge!(f.name => item.content) if item
      end

      return with_data
    end

  end
end


