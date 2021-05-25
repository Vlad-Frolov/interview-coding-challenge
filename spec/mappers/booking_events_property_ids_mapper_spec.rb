# frozen_string_literal: true

require 'mappers/booking_events_property_ids_mapper'
require 'repositories/event_repository'

RSpec.describe BookingEventsPropertyIdsMapper do
  subject { described_class.new(events_structures) }

  describe '#map' do
    context 'when events structures are empty' do
      let(:events_structures) { [] }

      it 'returns empty hash' do
        expect(subject.map).to be_empty
      end
    end

    context 'when events structures is not an Enumerable' do
      let(:events_structures) { :example }

      it 'returns nil' do
        expect(subject.map).to be_nil
      end
    end

    context 'when events structures contains events sorted by created_at(desc)' do
      # already have specs for EventRepository, guess can be used as data generator
      let(:events_structures) do
        EventRepository.new(source: JsonReader.new('data/events.json', 'events')).all.reverse
      end
      let(:expected_booking_events_values) do
        {
          1 => [
            { type: 'BookingCheckedIn', created_at: '2021-02-23 14:05:33 +0000' },
            { type: 'BookingCheckedOut', created_at: '2021-02-26 12:05:33 +0000' },
            { type: 'BookingCheckedIn', created_at: '2021-02-27 16:05:33 +0000' },
            { type: 'BookingCheckedOut', created_at: '2021-02-29 12:03:41 +0000' }
          ],
          2 => [
            { type: 'BookingCheckedIn', created_at: '2021-03-27 12:03:41 +0000' }
          ]
        }
      end

      it 'returns expected hash with sorted(asc) by created_at booking events values' do
        subject.map.each do |property_id, sorted_booking_events|
          expect(expected_booking_events_values[property_id]).to eq(
            sorted_booking_events.map { |str| { type: str.type, created_at: str.created_at } }
          )
        end
      end
    end
  end
end
