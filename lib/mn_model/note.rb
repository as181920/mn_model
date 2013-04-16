module MnModel
  class Note < ActiveRecord::Base
    establish_connection DB_CONFIGURATIONS

    def hi
      "hi note"
    end

  end
end
