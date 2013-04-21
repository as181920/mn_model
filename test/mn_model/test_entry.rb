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

  describe "CRUD for entries" do
    it "one note have no entries by default" do
      @note.entries.must_be_empty
    end

    it "one note have note entries and data" do
      entries_with_data = @note.entries_with_data()
      entries_with_data.must_be_instance_of Array
      entries_with_data.must_be_empty
    end

    it "can create entries with data for a note and get them back" do
      field_1_name, field_2_name = @note.fields[0].name, @note.fields[1].name
      field_1_content, field_2_content = "c1", "c2"

      entry_with_data = @note.create_entry_with_data field_1_name => field_1_content, field_2_name => field_2_content
      entry_with_data.must_be_instance_of Hash
      @note.entries.count.must_equal 1
      entry_with_data["data"][field_1_name].must_equal field_1_content
      entry_with_data["data"][field_2_name].must_equal field_2_content
      field_1_content, field_2_content = "c3", "c4"
      entry_with_data = @note.create_entry_with_data field_1_name => field_1_content, field_2_name => field_2_content
      @note.entries.count.must_equal 2
      entry_with_data["data"][field_1_name].must_equal field_1_content
      entry_with_data["data"][field_2_name].must_equal field_2_content

      # get entry
      entry_with_data = @note.find_entry_with_data "entry_id" => entry_with_data["id"]
      entry_with_data.must_be_instance_of Hash
      entry_with_data["data"][field_1_name].must_equal field_1_content

      # get all entries
      entries_with_data = @note.entries_with_data
      entries_with_data.must_be_instance_of Array
      entries_with_data.length.must_equal 2
      entries_with_data.last["data"][field_1_name].must_equal field_1_content
    end

    it "created entry will ignore unknown field data" do
      field_1_name, field_2_name, field_unknown = @note.fields[0].name, @note.fields[1].name, "unknown_field"
      field_1_content, field_2_content, field_unknown_content = "c1", "c2", "?"

      entry_with_data = @note.create_entry_with_data field_1_name => field_1_content, field_2_name => field_2_content, field_unknown => field_unknown_content
      @note.entries.count.must_equal 1
      @note.items.count.must_equal 2
      entry_with_data["data"][field_1_name].must_equal field_1_content
      entry_with_data["data"][field_unknown].must_be_nil
    end

    it "created entry with nil content for unset fields and unknown fields" do
      field_1_name, field_2_name = @note.fields[0].name, @note.fields[1].name
      field_1_content = "c1"

      entry_with_data = @note.create_entry_with_data field_1_name => field_1_content
      @note.entries.count.must_equal 1
      entry_with_data["data"][field_1_name].must_equal field_1_content
      entry_with_data["data"][field_2_name].must_be_nil
      entry_with_data["unknown_field"].must_be_nil
    end

  end

end