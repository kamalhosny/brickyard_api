require 'rails_helper'

RSpec.describe 'Vehicles', type: :request do
  let!(:user_one) { create(:user) }
  let!(:user_two) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let(:vehicle) { create(:vehicle) }
  let(:admin_headers) { { 'Authorization': token_generator(admin.id) } }
  let(:user_one_headers) { { 'Authorization': token_generator(user_one.id) } }
  let(:user_two_headers) { { 'Authorization': token_generator(user_two.id) } }

  describe 'GET #index' do
    it "returns a success response if the current user and the vehicles' user match" do
      create_list(:vehicle, 10, user_id: user_one.id)
      get "/users/#{user_one.id}/vehicles", headers: user_one_headers
      expect(response).to be_successful
      expect(json.count).to eq(10)
    end

    it "returns a unauthorized if the current user and the vehicles' user doesn't match" do
      create_list(:vehicle, 10, user_id: user_one.id)
      get "/users/#{user_one.id}/vehicles", headers: user_two_headers
      expect(response).to have_http_status(:unauthorized)
      expect(json['message']).to match(/you are not authorized to do this action/)
    end

    it 'returns a success response if the current user is admin' do
      create_list(:vehicle, 10, user_id: user_one.id)
      get "/users/#{user_one.id}/vehicles", headers: admin_headers
      expect(response).to be_successful
      expect(json.count).to eq(10)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'renders a JSON response with the new vehicle' do
        post "/users/#{user_one.id}/vehicles", params: { vehicle: attributes_for(:vehicle, user_id: user_one.id) },
                                               headers: user_one_headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new vehicle' do
        post "/users/#{user_one.id}/vehicles", params: { vehicle: attributes_for(:vehicle, description: '') },
                                               headers: user_one_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested vehicle' do
        vehicle = create(:vehicle, user_id: user_one.id)
        put "/users/#{user_one.id}/vehicles/#{vehicle.id}", params: { vehicle: { description: 'New description' } },
                                                            headers: user_one_headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(json['description']).to eq('New description')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the vehicle' do
        vehicle = create(:vehicle, user_id: user_one.id)
        put "/users/#{user_one.id}/vehicles/#{vehicle.id}", params: { vehicle: { description: '' } },
                                                            headers: user_one_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested vehicle' do
      vehicle = create(:vehicle, user_id: user_one.id)
      expect do
        delete "/users/#{user_one.id}/vehicles/#{vehicle.id}", headers: user_one_headers
      end.to change(Vehicle, :count).by(-1)
    end
  end
end
