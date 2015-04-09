require 'spec_helper'

RSpec.describe Api::V1::RatingsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      comment = FactoryGirl.create :comment
      rating_type = FactoryGirl.create :rating_type

      4.times { FactoryGirl.create :rating, comment: comment, rating_type: rating_type }
      #   get :index, user_id: current_user.id, spot_id: spot.id
      get :index, comment_id: comment.id
    end

    it "returns 4 comment records from the spot" do
      rating_response = json_response
      expect(rating_response.size).to eq(4)
    end

    it_behaves_like "paginated list"

    it { should respond_with 200 }
  end


  describe "GET #show" do
    before(:each) do
      comment = FactoryGirl.create :comment

      @rating = FactoryGirl.create :rating, comment: comment

      get :show, comment_id: comment.id, id: @rating.id
    end

    it "returns the rating record matching the id" do
      rating_response = json_response
      expect(rating_response[:id]).to eql @rating.id
    end


    it { should respond_with 200 }
  end


  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        current_user = FactoryGirl.create :user
        comment = FactoryGirl.create :comment
        rating_type = FactoryGirl.create :rating_type
        @rating_attributes = FactoryGirl.attributes_for :rating

        api_authorization_header current_user.auth_token

        post :create, {user_id: current_user.id, comment_id: comment.id, rating_type_id: rating_type.id, rating: @rating_attributes}

      end

      it "returns just user rating record" do
        rating_response = json_response
        expect(rating_response[:id]).to be_present
      end


      it { should respond_with 201 }
    end


    context "when is not created" do
       before(:each) do
         current_user = FactoryGirl.create :user
         comment = FactoryGirl.create :comment
         rating_type = FactoryGirl.create :rating_type

         api_authorization_header current_user.auth_token

         post :create, {user_id: current_user.id, comment_id: comment.id, rating_type_id: rating_type.id, rating: {value: ""}}
       end

       it "renders an errors json" do
         rating_response = json_response
         expect(rating_response).to have_key(:errors)
       end

       it "renders the json errors when the comment could not be created" do
         rating_response = json_response
         expect(rating_response[:errors][:value]).to include "can't be blank"
       end

       it { should respond_with 422 }
    end


  end



  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @comment = FactoryGirl.create :comment, user: @user
      @rating = FactoryGirl.create :rating, comment: @comment
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, comment_id: @comment.id, id: @rating.id, rating: { value: 7 } }
      end

      it "renders the json representation for the updated rating" do
        rating_response = json_response
        expect(rating_response[:value]).to eql 7.0
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, comment_id: @comment.id, id: @rating.id, rating: { value: nil } }
      end

      it "renders an errors json" do
        rating_response = json_response
        expect(rating_response).to have_key(:errors)
      end

      it "renders the json errors when the rating could not be created" do
        rating_response = json_response
        expect(rating_response[:errors][:value]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end


  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token


    end

    context "when is deleted" do
      before(:each) do
        @comment = FactoryGirl.create :comment, :user => @user
        @rating = FactoryGirl.create :rating, comment: @comment
        delete :destroy, { user_id: @user.id, comment_id: @comment.id, id: @rating.id }
      end

      it { should respond_with 204 }
    end


    context "when is not deleted - wrong user" do
      before(:each) do
        another_user = FactoryGirl.create :user
        @comment = FactoryGirl.create :comment, :user => another_user
        @rating = FactoryGirl.create :rating, comment: @comment
        delete :destroy, { user_id: @user.id, comment_id: @comment.id, id: @rating.id }
      end

      it { should respond_with 401 }
    end


  end


end
