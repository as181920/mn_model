require "minitest/autorun"
require "mn_model"

include MnModel

describe MnModel do
  before do
    Note.destroy_all
    Field.destroy_all
    Entry.destroy_all
    Item.destroy_all
    @note = Note.create name: "name_for_test"
    @note.fields.create name: "test_field_1"
    @note.fields.create name: "test_field_2"
  end

  describe "CRUD for entries" do
    it "one note have no entries by default" do
      @note.entries.must_be_empty
    end

    it "one note have note entries and data" do
      all_entries_with_data = @note.all_entries_with_data()
      all_entries_with_data.must_be_instance_of Array
      all_entries_with_data.must_be_empty
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

      # get entry with data by entry_id
      entry_with_data = @note.find_entry_with_data "entry_id" => entry_with_data["id"]
      entry_with_data.must_be_instance_of Hash
      entry_with_data["data"][field_1_name].must_equal field_1_content

      # get data by entry
      entry_with_data = Entry.find(entry_with_data["id"]).with_data
      entry_with_data.must_be_instance_of Hash
      entry_with_data["data"][field_1_name].must_equal field_1_content

      # get all entries
      # 1000.times {all_entries_with_data = @note.all_entries_with_data}
      all_entries_with_data = @note.all_entries_with_data
      all_entries_with_data.must_be_instance_of Array
      all_entries_with_data.length.must_equal 2
      all_entries_with_data.last["data"][field_1_name].must_equal field_1_content
    end

    it "can create entry with data by Entry" do
      field_1_name, field_2_name = @note.fields[0].name, @note.fields[1].name
      field_1_content, field_2_content = "c1", "c2"

      entry_with_data = @note.entries.create_with_data field_1_name => field_1_content, field_2_name => field_2_content
      entry_with_data.must_be_instance_of Hash
      @note.entries.count.must_equal 1
      entry_with_data["data"][field_1_name].must_equal field_1_content
      entry_with_data["data"][field_2_name].must_equal field_2_content
    end

    it "can find entry with data by Entry" do
      field_1_name, field_2_name = @note.fields[0].name, @note.fields[1].name
      field_1_content, field_2_content = "c1", "c2"

      entry_with_data = @note.create_entry_with_data field_1_name => field_1_content, field_2_name => field_2_content
      entry_with_data.must_be_instance_of Hash
      entry_with_data = Entry.find_with_data entry_with_data["id"]
      entry_with_data.must_be_instance_of Hash
      entry_with_data["data"][field_1_name].must_equal field_1_content
      entry_with_data["data"][field_2_name].must_equal field_2_content
    end

    it "can find all entries with data for a note by Entry" do
      field_1_name, field_2_name = @note.fields[0].name, @note.fields[1].name
      field_1_content, field_2_content = "c1", "c2"

      entry_with_data = @note.create_entry_with_data field_1_name => field_1_content, field_2_name => field_2_content
      all_entries_with_data = Entry.all_data note_id: @note.id
      all_entries_with_data.must_be_instance_of Array
      all_entries_with_data.length.must_equal 1
      all_entries_with_data.first["data"][field_1_name].must_equal field_1_content
      all_entries_with_data.first["note_id"].must_equal @note.id
      all_entries_with_data.first["entry_id"].must_equal entry_with_data["id"]
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

    it "created entry will ignore unsetted field and unknown fields" do
      field_1_name, field_2_name, field_unknown = @note.fields[0].name, @note.fields[1].name, "unknown_field"
      field_1_content = "c1"

      entry_with_data = @note.create_entry_with_data field_1_name => field_1_content, field_unknown => "?"
      @note.entries.count.must_equal 1
      @note.items.count.must_equal 1
      entry_with_data["data"].keys.must_include field_1_name
      entry_with_data["data"][field_1_name].must_equal field_1_content
      entry_with_data["data"].keys.wont_include field_2_name
      entry_with_data["data"].keys.wont_include field_unknown

      entry_with_data = @note.find_entry_with_data "entry_id" => entry_with_data["id"]
      entry_with_data["data"].keys.must_include field_1_name
      entry_with_data["data"][field_1_name].must_equal field_1_content
      entry_with_data["data"].keys.wont_include field_2_name
      entry_with_data["data"].keys.wont_include field_unknown
    end

    it "can create entry will field which value is empty" do
      field_1_name, field_2_name = @note.fields[0].name, @note.fields[1].name
      entry_with_data = @note.create_entry_with_data field_1_name => "x", field_2_name => ""
      entry_with_data["data"].keys.must_include field_1_name
      entry_with_data["data"].keys.must_include field_2_name
    end

  end

  describe "advanced query for entries" do
    before do
      #Note.destroy_all
      @note = Note.create name: "name_for_test"
      @note.fields.create name: "test_field_1"
      @note.fields.create name: "test_field_2"

      @field_1_name, @field_2_name = @note.fields[0].name, @note.fields[1].name
      5.times do |i|
        @note.create_entry_with_data @field_1_name => "field_1_content_#{i}", @field_2_name => "field_2_content_#{i}"
      end
      6.times do |i|
        @note.create_entry_with_data @field_1_name => "field_1_ccc_#{i}", @field_2_name => "field_2_ccc_#{i}"
      end
    end

    it "can get entries by conditions" do
      #TODO
    end

  end

end
