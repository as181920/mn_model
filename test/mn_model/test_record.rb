require "minitest/autorun"
require "mn_model"

include MnModel

describe MnModel do
  before do
    #Note.destroy_all
    @note = Note.create name: "name_for_test"
    @note.fields.create name: "test_field_1"
    @note.fields.create name: "test_field_2"
  end

  describe "CRUD for Records" do
    it "one note have no records by default" do
      @note.records.must_be_empty
    end

    it "can create one record for a note" do
      field_id_1 = @note.fields[0].id
      field_id_2 = @note.fields[1].id
      record = @note.create_record_with_date test_field_1: "x1", test_field_2: "x2"
      @note.records.count.must_equal 1
    end
  end

end
