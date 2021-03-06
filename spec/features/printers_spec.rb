require 'spec_helper'

feature 'Printer' do
  scenario 'page exists' do
    visit new_printer_path
    page.should have_text("List your shop!")
  end

  scenario 'creates an account' do
    create(:city, name: "Boulder")
    visit new_printer_path
    fill_in 'Shop name', with: 'Screenprintly'
    select 'Boulder', from: 'City'
    fill_in 'Contact name', with: 'dave woodall'
    fill_in 'Email', with: 'dave@screenprintly.com'
    fill_in 'Address', with: '123 main st.'
    fill_in 'Zipcode', with: '12345'
    click_button 'Create Printer'
    # page should redirect to printer show, with a flash that says 'success, you are now logged in!'
  end

  scenario 'errors are displayed when content is invalid' do
    visit new_printer_path
    build(:printer, email: nil, contact_name: nil, shop_name: nil, zipcode: nil, address: nil, phone: nil)
    click_button 'Create Printer'

    page.should have_text("Email can't be blank")
    page.should have_text("Contact name can't be blank")
    page.should have_text("Shop name can't be blank")
    page.should have_text("Zipcode can't be blank")
    page.should have_text("Address can't be blank")
    page.should have_text("Phone can't be blank")
  end

  scenario 'has a show page which display specific contact information' do
    create(:city)
    printer = create(:printer)
    visit printers_path
    visit printer_path(printer)
    page.should have_text("screenprintly")
  end


  context 'can update' do
    scenario ' basic information' do
        printer = create :printer
        visit printer_path printer
        click_link 'Edit info'
        page.should have_text("Edit your information")
        click_button 'Update Printer'
        page.should have_text(printer.shop_name)
    end

  end
  context 'organized by cities' do

    scenario 'boulder only shows printers in boulder' do
        boulder = create(:city, name: "Boulder")
        denver = create(:city, name: "Denver")
        visit cities_path
        click_link "Boulder"
        page.should have_text("Listing Boulder printers")
    end

    scenario 'has a list of printers in that city' do
        boulder = create(:city, name: "Boulder")
        printer = create(:printer, city: boulder)
        visit cities_path
        click_link "Boulder"
        page.should have_text("screenprintly")
    end

    scenario 'the list of printers are links to printer show pages' do
        boulder = create(:city, name: "Boulder")
        printer = create(:printer, city: boulder)
        visit cities_path
        click_link "Boulder"
        click_link "screenprintly"
        page.should have_text(printer.shop_name)

    end
  end
end


