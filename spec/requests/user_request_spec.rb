require 'rails_helper'

RSpec.describe "Users", type: :request do

  RSpec.shared_context 'with multiple companies' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times do
        create(:user, company: company_1)
      end
      5.times do
        create(:user, company: company_2)
      end
    end
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body) }

    context 'when fetching users by company' do
      include_context 'with multiple companies'

      it 'returns only the users for the specified company' do
        get company_users_path(company_1)
        
        expect(result.size).to eq(company_1.users.size)
        expect(result.map { |element| element['id'] } ).to eq(company_1.users.ids)
      end
    end

    context 'when fetching all users' do
      include_context 'with multiple companies'

      it 'returns all the users' do
        get users_path
        
        expect(result.size).to eq(User.count)
        expect(result.map { |element| element['id'] }.sort).to eq(User.ids.sort)
      end
    end

    context 'when filtering by partial username (case-insensitive)' do
      let!(:matching_user_1) { create(:user, username: 'maxwell') }
      let!(:matching_user_2) { create(:user, username: 'Matilda') }
      let!(:non_matching_user) { create(:user, username: 'john') }

      it 'returns users that partially match the username' do
        get users_path, params: { username: 'ma' }

        expect(result.map { |user| user['username'] }).to include('maxwell', 'Matilda')
        expect(result.map { |user| user['username'] }).not_to include('john')
      end
    end
  end
end
