# frozen_string_literal: true

require 'system_helper'

describe "Taxonomies" do
  include AuthenticationHelper
  include WebHelper

  before(:each) do
    login_as_admin_and_visit spree.edit_admin_general_settings_path
  end

  context "show" do
    it "should display existing taxonomies" do
      create(:taxonomy, name: 'Brand')
      create(:taxonomy, name: 'Categories')
      click_link "Taxonomies"
      within("table.index tbody") do
        expect(page).to have_content("Brand")
        expect(page).to have_content("Categories")
      end
    end
  end

  context "create" do
    before(:each) do
      click_link "Taxonomies"
      click_link "admin_new_taxonomy_link"
    end

    it "should allow an admin to create a new taxonomy" do
      expect(page).to have_content("New Taxonomy")
      fill_in "taxonomy_name", with: "sports"
      click_button "Create"
      expect(page).to have_content("successfully created!")
    end

    it "should display validation errors" do
      fill_in "taxonomy_name", with: ""
      click_button "Create"
      expect(page).to have_content("can't be blank")
    end
  end

  context "edit" do
    it "should allow an admin to update an existing taxonomy" do
      create(:taxonomy)
      click_link "Taxonomies"
      within_row(1) { find(".icon-edit").click }
      fill_in "taxonomy_name", with: "sports 99"
      click_button "Update"
      expect(page).to have_content("successfully updated!")
      expect(page).to have_content("sports 99")
    end
  end
  
  context "rename" do 
    it "should allow an admin to rename a taxon in taxonomy tree" do
      create(:taxonomy)
      click_link "Taxonomies"
      need to figure out how to add a taxon (i dont know if create does this)
      within_row(2) { find(".icon-rename").click } //i feel like row 1 might be for the whole tree, so maybe row 2 instead?
      fill_in "taxonomy_name", with: "renamed"
      click_button "Update"
      click_link "Taxonomies" //need to get to the page with the taxons
      expect(page).to have_content("sports 99")
      end
    end
end
