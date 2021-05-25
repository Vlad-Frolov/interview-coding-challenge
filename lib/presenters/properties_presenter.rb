# frozen_string_literal: true

# presents properties as: Array[ [roperty_id, property_title, property_status] ]

class PropertiesPresenter
  def initialize(properties, booking_events_by_property_id = {})
    @properties = properties
    @booking_events_by_property_id = booking_events_by_property_id
  end

  def present
    return unless properties.is_a? Enumerable

    @properties.map do |property|
      [property.id, property.title, property_status(booking_events_by_property_id[property.id]&.last)]
    end
  end

  private

  # we have only two types of Bookings events: BookingCheckedIn, BookingCheckedOut
  def property_status(last_booking_event)
    last_booking_event.nil? || last_booking_event.type == 'BookingCheckedOut' ? 'empty' : 'occupied'
  end

  attr_reader :properties, :booking_events_by_property_id
end
