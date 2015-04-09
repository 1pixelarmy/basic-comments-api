require 'spec_helper'

RSpec.describe Api::V1::RatingTypesController, type: :controller do
  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :rating_type}
      get :index
    end

    it "returns 4 rating types" do
      rating_types_response = json_response
      expect(rating_types_response.size).to eq(4)
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      @rating_type = FactoryGirl.create :rating_type

      get :show, id: @rating_type.id
    end

    it "returns the rating_type record matching the id" do
      rating_type_response = json_response
      expect(rating_type_response[:id]).to eql @rating_type.id
    end


    it { should respond_with 200 }
  end
end
