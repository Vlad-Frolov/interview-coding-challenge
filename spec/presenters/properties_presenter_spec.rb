# frozen_string_literal: true

require 'presenters/properties_presenter'
require 'repositories/property_repository'
require 'repositories/event_repository'

RSpec.describe PropertiesPresenter do
  subject { described_class.new(property_structures, booking_events_by_property_id) }

  let(:booking_events_by_property_id) { {} }

  describe '#present' do
    context 'when property structures are empty' do
      let(:property_structures) { [] }

      it 'returns empty array' do
        expect(subject.present).to be_empty
      end
    end

    context 'when property structures is not an Enumerable' do
      let(:property_structures) { :example }

      it 'returns nil' do
        expect(subject.present).to be_nil
      end
    end

    context 'when property structures are not empty' do
      let(:property_structures) do
        [
          PropertyRepository::Property.new(1, 'Test1'),
          PropertyRepository::Property.new(2, 'Test2'),
          PropertyRepository::Property.new(3, 'Test3')
        ]
      end

      context 'when booking events by property id are empty' do
        it 'returns array of presented properties fields arrays with expected statuses' do
          expect(subject.present).to eq([[1, 'Test1', 'empty'], [2, 'Test2', 'empty'], [3, 'Test3', 'empty']])
        end
      end

      context 'when booking events by property id are not empty' do
        let(:booking_events_by_property_id) do
          {
            1 => [EventRepository::Event.new('BookingCheckedIn')],
            2 => [EventRepository::Event.new('BookingCheckedOut')],
            3 => []
          }
        end

        it 'returns array of presented properties fields arrays with expected statuses' do
          expect(subject.present).to match_array(
            [[1, 'Test1', 'occupied'], [2, 'Test2', 'empty'], [3, 'Test3', 'empty']]
          )
        end
      end
    end
  end
end
