require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe 'GET /users/:id' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers }

    context 'When User exists' do
      before { get "/users/#{user.id}", headers: headers }

      it 'returns the user object' do
        expect(json).not_to be_nil
        expect(json['name']).to eq(user.name)
      end
    end

    context 'When User is not found' do
      before { get '/users/100', headers: headers }

      it 'returns a failure message' do
        expect(json['message']).to match(/Couldn't find User with 'id'=100/)
      end
    end
  end
end
