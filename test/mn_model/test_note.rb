require "minitest/autorun"
require "mn_model"

include MnModel

describe MnModel do
  before do
    Note.destroy_all
  end

  describe "CRUD for Note" do
    it "must have no notes by default" do
      Note.all.must_be_empty
    end

    it "can CRUD note with name and description" do
      name, desc = "testnote1", "the note is used for testing"
      note = Note.create name: name, description: desc
      Note.all.count.must_equal 1
      note.name.must_equal name
      note.description.must_equal desc

      note = Note.find note.id
      note.wont_be_nil

      name_modified = "testnote2"
      note.name = name_modified
      note.save
      note.name.must_equal name_modified

      note.destroy
      Note.all.must_be_empty
    end

    it "name should not empty" do
      proc {Note.create!}.must_raise ActiveRecord::RecordInvalid
      note = Note.create
      note.valid?.must_equal false
    end

  end

end
