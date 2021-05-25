#!/usr/bin/env ruby

# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].sort.each(&method(:require))

events_structures = EventRepository.new(source: JsonReader.new('data/events.json', 'events')).all.reverse
booking_events_by_property_id = BookingEventsPropertyIdsMapper.new(events_structures).map
properties_structures = PropertyRepository.new(source: JsonReader.new('data/properties.json', 'properties')).all

puts PropertiesPresenter.new(properties_structures, booking_events_by_property_id).present
