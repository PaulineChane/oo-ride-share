# frozen_string_literal: true

require_relative 'csv_record'
# This is a class for the driver object
module RideShare
  class Driver < CsvRecord
    # generic readers
    attr_reader :name, :vin, :status, :trips
    # constructor
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      raise ArgumentError, 'Invalid VIN entry. Must be 17 characters in length' if vin.length != 17
      if status != :AVAILABLE && status != :UNAVAILABLE
        raise ArgumentError, 'Invalid STATUS entry. Must be one of :AVAILABLE or :UNAVAILABLE'
      end

      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end

    # readers
    def average_rating
      # By getting each trip data, there must be a collection for the trip rating from "ADD TRIP"
      # Taking each rating value from the trip, sum it up and divide by the total number of trips OF the DRIVER.

      trips.empty? ? 0 : @trips.inject(0.0) { |sum, trip| sum + trip.rating } / @trips.length
    end

    def total_revenue
      # @trips.empty? ? 0 : @trips.inject(0) { |total_cost, trip| total_cost + trip.cost }
      if @trips.empty?
        0
      else
        # variable to store each trip cost
        # .each loop to take cost fromm each trip
        # first subtract 1.65 from the cost, and then apply 80% division for driver's income total
        total_income = 0

        @trips.each do |trip|
          if trip.cost <= 1.65
            total_income += (trip.cost * 0.80).round(2)
          else
            total_income += ((trip.cost.to_f - 1.65) * 0.80).round(2)
          end
        end

        return total_income
      end
    end

    # writers
    def add_trip(trip)
      @trips << trip
    end

    # class methods
    def self.from_csv(record)
      new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end
