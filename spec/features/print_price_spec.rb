require 'spec_helper'

feature 'Print pricing' do
  scenario 'has new price tier page' do
    screenprintly = create(:printer)
    visit printer_path(screenprintly)
    click_link 'Add a price tier'
    page.should have_text("Add a new price tier")
  end

  scenario 'can be added by filling out the form' do
    create(:city)
    printer = create(:printer)
    visit printer_path(printer)
    click_link 'Add a price tier'
    select('1 - 11', :from => 'print_price_price_tier')
    select('standard', :from => 'Pallet type')
    select('plastisol', :from => 'Ink type')
    fill_in "Base color", with: 234
    fill_in "One color", with: 234
    fill_in "Two color", with: 234
    fill_in "Three color", with: 234
    click_button "Create price tier"
    page.should have_text(printer.shop_name)
  end
end