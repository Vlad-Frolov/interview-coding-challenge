# frozen_string_literal: true

require 'time'

# class is designed to return hash: { preperty_id => Array[BookingEventStructure](sorted by created_at asc) }
class BookingEventsPropertyIdsMapper
  def initialize(events_structures)
    @events_structures = events_structures
  end

  def map
    return @map if @map

    return unless events_structures.is_a? Enumerable

    part_events_structures_by_property_id

    # it can be a situation that events.json is not sorted properly by created at
    @map = property_id_with_booking_events_structures.group_by(&:first).transform_values do |events|
      events.map(&:last).flatten.sort_by { |event| Time.parse(event.created_at) }
    end
  end

  private

  def part_events_structures_by_property_id
    @properties_events, @booking_events = events_structures.partition { |event| event.data['property_id'] }
  end

  def booking_events_by_booking_id
    @booking_events_by_booking_id ||= booking_events.group_by { |event| event.data['booking_id'] }
  end

  def property_id_with_booking_events_structures
    @property_id_with_booking_events_structures ||= properties_events.map do |property_event|
      [property_event.data['property_id'], booking_events_by_booking_id[property_event.data['booking_id']]]
    end
  end

  attr_reader :events_structures, :properties_events, :booking_events
end
