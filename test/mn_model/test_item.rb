require "minitest/autorun"
require "mn_model"

include MnModel

describe MnModel do
  before do
    #Note.destroy_all
    #Field.destroy_all
    Item.destroy_all
    #@note = Note.create name: "name_for_test"
    #@note.fields.create name: "test_field_1"
    @entry_id = 1
    @field_id = 11
    @content = 'x'
  end

  describe "CRUD for Item" do
    it "must have no items by default" do
      Item.all.must_be_empty
    end

    it "can CRUD item" do

      item = Item.create entry_id: @entry_id,field_id: @field_id,content: @content
      Item.all.count.must_equal 1
      item.entry_id.must_equal @entry_id
      item.content.must_equal @content

      item = Item.find item.id
      item.wont_be_nil

      content_modified = "xx"
      item.content = content_modified
      item.save
      item.content.must_equal content_modified

      item.destroy
      Item.all.must_be_empty
    end

    it "entry_id and field_id and content should not empty" do
      proc {Item.create!}.must_raise ActiveRecord::RecordInvalid
      proc {Item.create!(field_id: @field_id,entry_id: @entry_id)}.must_raise ActiveRecord::RecordInvalid
      proc {Item.create!(field_id: @field_id,content: @content)}.must_raise ActiveRecord::RecordInvalid
      proc {Item.create!(entry_id: @entry_id,content: @content)}.must_raise ActiveRecord::RecordInvalid
    end

  end

end
