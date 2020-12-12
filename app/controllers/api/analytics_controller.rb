class Api::AnalyticsController < ApplicationController
    def test 
        render json: {message: 'success'}, status: 200
    end

    def register
        # binding.pry
        new_device = Device.new(id: UUID.new.generate, phone_number: params[:phone_number], carrier: params[:carrier])
        if new_device.save
            render json: {device_id: new_device.id}, status: 200
        else
            render json: {}, status: 500
        end
    end

    def alive

    end

    def report

    end

    def terminate

    end
end