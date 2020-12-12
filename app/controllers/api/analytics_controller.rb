class Api::AnalyticsController < ApplicationController
    def test 
        render json: {message: 'success'}, status: 200
    end
end