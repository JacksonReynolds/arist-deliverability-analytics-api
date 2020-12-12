require 'rails_helper'

RSpec.describe "Analytics", type: :request do
    describe "GET #test" do 
        before do
            get '/api/test'
        end

        it 'is successful' do
            expect(response).to have_http_status(:success)
        end
    end

    describe "POST #register" do
        before do
            register_params = {phone_number: '+1 (222) 222-2222', carrier: 'verizon'}
            post '/api/register', :params => register_params, :headers => 
        end

        it 'is successful' do
            expect(response).to have_http_status(:success)
        end

        it 'returns a device id' do
            expect(response)
        end

        it 'crates a new Device record' do
            device_id = JSON.parse(response.body)['device_id']
            device = Device.find_by(id: device_id)

        end
    end
end
