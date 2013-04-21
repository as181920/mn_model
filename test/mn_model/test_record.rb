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

    it "can create record with data for a note" do
      field_1_name, field_2_name = @note.fields[0].name, @note.fields[1].name
      field_1_content, field_2_content = "c1", "c2"

      record_with_data = @note.create_record_with_date field_1_name => field_1_content, field_2_name => field_2_content
      record_with_data.must_be_instance_of Hash
      @note.records.count.must_equal 1
      record_with_data[field_1_name].must_equal field_1_content
    end

    it "created record will ignore unknown field data" do
      field_1_name, field_2_name, field_unknown = @note.fields[0].name, @note.fields[1].name, "unknown_field"
      field_1_content, field_2_content, field_unknown_content = "c1", "c2", "?"

      record_with_data = @note.create_record_with_date field_1_name => field_1_content, field_2_name => field_2_content, field_unknown => field_unknown_content
      @note.records.count.must_equal 1
      @note.items.count.must_equal 2
      record_with_data[field_1_name].must_equal field_1_content
      record_with_data[field_unknown].must_be_nil
    end

    it "created record with nil content for unset fields and unknown fields" do
      field_1_name, field_2_name = @note.fields[0].name, @note.fields[1].name
      field_1_content = "c1"

      record_with_data = @note.create_record_with_date field_1_name => field_1_content
      @note.records.count.must_equal 1
      record_with_data[field_1_name].must_equal field_1_content
      record_with_data[field_2_name].must_be_nil
      record_with_data["unknown_field"].must_be_nil

    end
  end

end
