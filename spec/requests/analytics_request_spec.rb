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
end
