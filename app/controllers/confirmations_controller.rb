class ConfirmationsController < ApplicationController
  include ConfirmationsHelper

  def index
  end

  def new
    @session = Session.find_by_session_id(session['session_id'])
    @garment = GarmentSelector.find(@session.garment_id)
    @quote = Quote.find(@session.quote_id)

    @printer = Printer.find_by_slug!(params[:printer_id])
    @garment_selector = GarmentSelector.find(params[:garment_selector_id])


    @quote_tier = @quote.quote_quantity(@quote.quantity)
    @quote_tier_all = PrintPrice.where(price_tier: @quote_tier, printer_id: @printer)
    @print_price = @quote_tier_all.first.send(@quote.number_of_colors)

    @confirmation = Confirmation.new
  end

  def create
    @session = Session.find_by_session_id(session['session_id'])
    @printer = Printer.find_by_slug!(params[:printer_id])
    @quote = Quote.find(@session.quote_id)

    @garment_selector = GarmentSelector.find(params[:garment_selector_id])
    @garment = GarmentSelector.find(@session.garment_id)

    @quote_tier = @quote.quote_quantity(@quote.quantity)
    @quote_tier_all = PrintPrice.where(price_tier: @quote_tier, printer_id: @printer)
    @print_price = @quote_tier_all.first.send(@quote.number_of_colors)

    @confirmation = Confirmation.create(
      color: @quote.number_of_colors,
      garment: @garment.short_sleeve_tshirt,
      printer_id: @printer.id,
      city: @printer.city.id,

      total_invoice: total_order(@quote.quantity.to_i, @print_price.to_i, @garment.garment_price.to_i),

      piece_price: price_per_shirt(total_order(@quote.quantity.to_i, @print_price.to_i, @garment.garment_price.to_i), @quote.quantity)
      )

    if @confirmation.save
      redirect_to printer_garment_selector_confirmation_path(@printer, @garment_selector, @confirmation)
    else
      render 'new'
    end
  end

  def show
    @printer = Printer.find_by_slug!(params[:printer_id])
  end
end