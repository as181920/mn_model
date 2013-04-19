require "minitest/autorun"
require "mn_model"

include MnModel

describe MnModel do
  before do
    Note.destroy_all
    @note = Note.create name: "name_for_test"
  end

  describe "CRUD for Records" do
    it "one note have no records by default" do
      @note.records.must_be_empty
    end
  end

end
