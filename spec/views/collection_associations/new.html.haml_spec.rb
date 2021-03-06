require "rails_helper"

RSpec.describe "collection_associations/new" do
  # NOTE: using a few non-doubles here for cleanliness. Forms need many fields
  # and mocking them is cluttered. I've doubled everything that it made sense to.
  before do
    allow(Language).to receive(:current) { "this" }
    item = instance_double("Collection", icon: "image_thingie.jpg", id: 43123)
    allow(item).to receive(:name) { "Here Titled" }
    collection_association = CollectionAssociation.new(associated_id: item.id)
    assign(:associated, item)
    assign(:collection, Collection.new)
    assign(:collection_association, collection_association)
  end

  context "with a new user" do
    before do
      user = instance_double("User", collections: [])
      assign(:bad_collection_ids, [])
      allow(view).to receive(:current_user) { user }
    end

    it "shows the icon of the collected item" do
      render
      expect(rendered).to match /image_thingie.jpg/
    end

    it "shows the name of the collected item in the current language" do
      render
      expect(rendered).to match /Here Titled/
    end

    it "shows no collections to select" do
      render
      expect(rendered).to match(
        /#{CGI.escapeHTML(I18n.t(:collect_no_existing_collections))}/)
    end

    it "shows a form for a new collection" do
      render
      expect(rendered).to have_selector("form#new_collection")
    end
  end

  context "with a user who has collections already" do
    before do
      collection_1 = create(:collection, updated_at: 1.hour.ago,
        name: "Collection One", id: 1)
      collection_2 = create(:collection, updated_at: 1.minute.ago,
        name: "Collection Two", id: 2)
      collection_bad = create(:collection, updated_at: 2.hours.ago,
        name: "Collection Bad", id: 3)
      user_collections = [collection_1, collection_2, collection_bad]
      user = instance_double("User", collections: user_collections)
      assign(:bad_collection_ids, [collection_bad.id])
      allow(view).to receive(:current_user) { user }
    end

    it "shows all of the available collections" do
      render
      expect(rendered).to match /Collection One/
      expect(rendered).to match /Collection Two/
      expect(rendered).to match /Collection Bad/
    end

    it "shows the newest collection first" do
      render
      expect(rendered).to match /Collection Two.*Collection One/m
    end

    it "disables the bad collection option" do
      render
      expect(rendered).to have_selector(
        "input#collection_association_collection_id_3[disabled]")
    end
  end
end
