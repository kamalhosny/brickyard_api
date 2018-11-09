require 'rails_helper'
RSpec.describe StatesController, type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let(:headers) { { 'Authorization': token_generator(admin.id) } }
  let(:invalid_headers) { { 'Authorization': token_generator(user.id) } }

  describe 'GET #index' do
    it 'returns a success response' do
      create_list(:state, 10)
      get '/states', headers: headers
      expect(response).to be_successful
      expect(json.count).to eq(10)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'renders a JSON response with the new state' do
        post '/states', params: { state: attributes_for(:state) }, headers: headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new state' do
        post '/states', params: { state: attributes_for(:state, :without_name) }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid headers _ regular user' do
      it "return Unauthorized status with error message 'This action can be done by admins only' " do
        post '/states', params: { state: attributes_for(:state, :without_name) }, headers: invalid_headers
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq('application/json')
        expect(json['message']).to match(/This action can be done by admins only/)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested state' do
        state = create(:state)
        put "/states/#{state.id}", params: { state: { name: 'Tested' } }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(json['name']).to eq('Tested')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the state' do
        state = create(:state)
        put "/states/#{state.id}", params: { state: { name: '' } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested state' do
      state = create(:state)
      expect { delete "/states/#{state.id}", headers: headers }.to change(State, :count).by(-1)
    end
  end
end
