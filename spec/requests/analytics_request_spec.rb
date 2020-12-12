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

        describe "with valid data" do
            before do
                # binding.pry
                header = {"accepts": 'application/json'}
                good_params = {phone_number: '+18004663337', carrier: 'tmobile'} # homedepot customer service as a control, made up carrier
                post '/api/register', :params => good_params, :headers => header
                @device_id = JSON.parse(response.body)['device_id']
                @device = Device.find_by(id: @device_id)
            end

            it 'returns successful' do
                expect(response).to have_http_status(:success)
            end


            it 'returns a device_id' do
                expect(@device_id).not_to be_nil
            end

            it 'creates a Device record' do
                expect(@device).to be_an_instance_of(Device)
            end
        end

        describe 'with invalid params' do
            before do
                header = {"accepts": 'application/json'}
                bad_phone_params = {phone_number: '1111111111', carrier: 'tmobile'}
                post '/api/register', :params => bad_phone_params, :headers => header
                @device_id = JSON.parse(response.body)['device_id']
                @device = Device.find_by(id: @device_id)
            end

            it 'returns 500 status' do
                expect(response).to have_http_status(:error)
            end

            it 'has error messages' do
                binding.pry
                expect(response.body).to eq("{\"errors\":[\"Phone number is invalid\"]}")
            end
        end
    end
end
