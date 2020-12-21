require 'rails_helper'

RSpec.describe "Analytics", type: :request do

  describe "POST #register" do
    context "with valid params" do
      before do
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

    context 'with invalid params' do
      before do
        header = {"accepts": 'application/json'}
        bad_phone_params = {phone_number: '1111111111', carrier: ''}
        post '/api/register', :params => bad_phone_params, :headers => header
        @device_id = JSON.parse(response.body)['device_id']
        @device = Device.find_by(id: @device_id)
      end

      it 'returns 500 status' do
        expect(response).to have_http_status(:error)
      end

      it 'has error messages' do
        expect(response.body).to include("Phone number is invalid")
        expect(response.body).to include("Carrier can't be blank")
      end
    end
  end

  describe "POST #alive" do

    context "with valid params" do
      before do
        valid_device = Device.create(phone_number: "+18004663337", carrier: 'tmobile')

        header = {"accepts": 'application/json'}
        post '/api/alive', :params => {device_id: valid_device.id}, :headers => header
      end

      it 'returns successful' do
        expect(response).to have_http_status(:success)
      end

      it 'creates a new heartbeat record' do
        expect(assigns(:hb)).to be_an_instance_of(Heartbeat)
      end
    end

    context "with invalid device_id" do
      before do
        header = {"accepts": 'application/json'}
        post '/api/alive', :params => {device_id: ''}, :headers => header
      end

      it 'returns a 500 status' do
        expect(response).to have_http_status(:error)
      end

      it 'has error message' do
        expect(response.body).to include("Device_id invalid")
      end
    end

    context "with disabled device" do
      before do
        disabled_device = Device.create(phone_number: "+18004663337", carrier: 'tmobile', disabled_at: DateTime.now)
        header = {"accepts": 'application/json'}
        post '/api/alive', :params => {device_id: disabled_device.id}, :headers => header
      end

      it 'returns a 500 status' do
        expect(response).to have_http_status(:error)
      end

      it 'has error message' do
        expect(response.body).to include("Device is disabled")
      end
    end
  end

  describe "POST #report" do

    context "with valid params" do
      before do
        valid_device = Device.create(phone_number: "+18004663337", carrier: 'tmobile')

        header = {"accepts": 'application/json'}
        good_params = {device_id: valid_device.id, message: 'Ohai', sender: 'me'}
        post '/api/report', :params => good_params, :headers => header
      end

      it 'returns successful' do
        expect(response).to have_http_status(:success)
      end

      it 'creates a new report record' do
        expect(assigns(:report)).to be_an_instance_of(Report)
      end
    end

    context 'with invalid device_id' do
      before do
        header = {"accepts": 'application/json'}
        bad_params = {device_id: '', message: 'Ohai', sender: 'me'}
        post '/api/report', :params => bad_params, :headers => header
      end

      it 'returns a 500 status' do
        expect(response).to have_http_status(:error)
      end

      it 'has error message' do
        expect(response.body).to include("Device_id invalid")
      end
    end

    context "with disabled device" do
      before do
        disabled_device = Device.create(phone_number: "+18004663337", carrier: 'tmobile', disabled_at: DateTime.now)

        header = {"accepts": 'application/json'}
        post '/api/report', :params => {device_id: disabled_device.id}, :headers => header
      end

      it 'returns a 500 status' do
        expect(response).to have_http_status(:error)
      end

      it 'has error message' do
        expect(response.body).to include("Device is disabled")
      end
    end

    context "with missing message or sender" do
      before do
        valid_device = Device.create(phone_number: "+18004663337", carrier: 'tmobile')

        header = {"accepts": 'application/json'}
        bad_params = {device_id: valid_device.id, message: nil, sender: nil}
        post '/api/report', :params => bad_params, :headers => header
      end

      it 'returns a 500 status' do
        expect(response).to have_http_status(:error)
      end

      it 'has error messages' do
        expect(response.body).to include("Message can't be blank", "Sender can't be blank")
      end
    end
  end

  describe "PATCH #terminate" do

    context 'with valid params' do
      before do
        valid_device = Device.create(phone_number: "+18004663337", carrier: 'tmobile')

        header = {"accepts": 'application/json'}
        patch '/api/terminate', :params => {device_id: valid_device.id}, :headers => header
      end

      it 'returns successful' do
        expect(response).to have_http_status(:success)
      end

      it 'disables the device' do
        expect(assigns(:device).disabled?).to eq(true)
      end
    end

    context "with invalid device_id" do
      before do
        header = {"accepts": 'application/json'}
        patch '/api/terminate', :params => {device_id: ''}, :headers => header
      end

      it 'returns a 500 status' do
        expect(response).to have_http_status(:error)
      end

      it 'has error message' do
        expect(response.body).to include("Invalid device_id")
      end
    end

    context "with disabled device" do
      before do
        disabled_device = Device.create(phone_number: "+18004663337", carrier: 'tmobile', disabled_at: DateTime.now)

        header = {"accepts": 'application/json'}
        patch '/api/terminate', :params => {device_id: disabled_device.id}, :headers => header
      end

      it 'returns a 500 status' do
        expect(response).to have_http_status(:error)
      end

      it 'has error message' do
        expect(response.body).to include("Device is disabled")
      end
    end
  end
end
