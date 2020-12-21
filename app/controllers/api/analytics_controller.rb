class Api::AnalyticsController < ApplicationController

    def register
        new_device = Device.new(phone_number: params[:phone_number], carrier: params[:carrier])
        if new_device.save
            render json: {device_id: new_device.id}, status: 201
        else
            render json: {errors: new_device.errors.full_messages}, status: 500
        end
    end

    def alive
        device = Device.find_by(id: params[:device_id])
        if device
            @hb = device.heartbeats.build
            if @hb.save
                render json: {}, status: 201
            else
                render json: {errors: @hb.errors.full_messages}, status: 500
            end
        else
            render json: {errors: "Device_id invalid"}, status: 500
        end
    end

    def report
        device = Device.find_by(id: params[:device_id])
        if device
            @report = device.reports.build(sender: params[:sender], message: params[:message])
            if @report.save
                render json: {}, status: 201
            else
                render json: {errors: @report.errors.full_messages}, status: 500
            end
        else
            render json: {errors: "Device_id invalid"}, status: 500
        end
    end

    def terminate
        @device = Device.find_by(id: params[:device_id])
        if @device
            if !@device.disabled? && @device.update(disabled_at: DateTime.now)
                render json: {}, status: 200
            else
                render json: {error: "Device is disabled"}, status: 500
            end
        else
            render json: {error: 'Invalid device_id'}, status: 500
        end
    end
end