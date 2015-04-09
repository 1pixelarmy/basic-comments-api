require 'spec_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :comment}
      get :index
    end

    it "returns 4 comment" do
      comment_response = json_response
      expect(comment_response.size).to eq(4)
    end

    it_behaves_like "paginated list"

    it { should respond_with 200 }
  end


  describe "GET #show" do
    before(:each) do
      current_user = FactoryGirl.create :user

      @comment = FactoryGirl.create :comment

      get :show, user_id: current_user.id, id: @comment.id
    end

    it "returns the comment record matching the id" do
      comment_response = json_response
      expect(comment_response[:id]).to eql @comment.id
    end


    it { should respond_with 200 }
  end


  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        current_user = FactoryGirl.create :user
        @comment_attributes = FactoryGirl.attributes_for :comment

        api_authorization_header current_user.auth_token

        post :create, {user_id: current_user.id, comment: @comment_attributes}

      end

      it "returns just user comment record" do
        comment_response = json_response
        expect(comment_response[:id]).to be_present
      end


      it { should respond_with 201 }
    end


    context "when is not created" do
      before(:each) do
        current_user = FactoryGirl.create :user
        api_authorization_header current_user.auth_token

        post :create, {user_id: current_user.id, comment: {body: ""}}
      end

      it "renders an errors json" do
        comment_response = json_response
        expect(comment_response).to have_key(:errors)
      end

      it "renders the json errors when the comment could not be created" do
        comment_response = json_response
        expect(comment_response[:errors][:body]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end


  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @comment = FactoryGirl.create :comment, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id,  id: @comment.id, comment: { body: "new body" } }
      end

      it "renders the json representation for the updated comment" do
        comment_response = json_response
        expect(comment_response[:body]).to eql "new body"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @comment.id, comment: { body: nil } }
      end

      it "renders an errors json" do
        comment_response = json_response
        expect(comment_response).to have_key(:errors)
      end

      it "renders the json errors when the comment could not be created" do
        comment_response = json_response
        expect(comment_response[:errors][:body]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end


  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @comment = FactoryGirl.create :comment, user: @user
      api_authorization_header @user.auth_token

      delete :destroy, { user_id: @user.id, id: @comment.id }
    end

    it { should respond_with 204 }
  end
end
