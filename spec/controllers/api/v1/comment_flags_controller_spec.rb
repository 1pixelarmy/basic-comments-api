require 'spec_helper'

RSpec.describe Api::V1::CommentFlagsController, type: :controller do

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        current_user = FactoryGirl.create :user
        @comment = FactoryGirl.create :comment

        @comment_flag_attributes = FactoryGirl.attributes_for :comment_flag

        api_authorization_header current_user.auth_token

        post :create, {user_id: current_user.id, comment_id: @comment.id, comment_flag: @comment_flag_attributes}

      end

      it "returns just one comment flag record" do
        comment_flag_response = json_response
        expect(comment_flag_response[:id]).to be_present
      end

      it "comment is not inappropriated" do
        expect(@comment.is_inappropriated?).to eql false
      end

      it { should respond_with 201 }
    end

    context "when same user tries to flag twice" do
      before(:each) do
        current_user = FactoryGirl.create :user
        @comment = FactoryGirl.create :comment

        @comment_flag_attributes = FactoryGirl.attributes_for :comment_flag

        api_authorization_header current_user.auth_token
        5.times {
          post :create, {user_id: current_user.id, comment_id: @comment.id, comment_flag: @comment_flag_attributes}
        }
      end

      it "comment is not inappropriated" do
        expect(@comment.is_inappropriated?).to eql false
      end

      it { should respond_with 400 }

    end


    context "when comment is inappropriated" do
      before(:each) do
        @comment = FactoryGirl.create :comment

        @comment_flag_attributes = FactoryGirl.attributes_for :comment_flag


        5.times {
          current_user = FactoryGirl.create :user
          api_authorization_header current_user.auth_token
          post :create, {user_id: current_user.id, comment_id: @comment.id, comment_flag: @comment_flag_attributes}
        }

      end


      it "comment is inappropriated" do
        expect(@comment.is_inappropriated?).to eql true
      end

    end

   end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @comment = FactoryGirl.create :comment
      api_authorization_header @user.auth_token
    end

    context "when is deleted" do
      before(:each) do
        @comment_flag = FactoryGirl.create :comment_flag, comment: @comment, :user => @user
        delete :destroy, { user_id: @user.id, comment_id: @comment.id, id: @comment_flag.id }
      end

      it { should respond_with 204 }
    end

    context "when is not deleted - wrong user" do
      before(:each) do
        another_user = FactoryGirl.create :user
        @comment_flag = FactoryGirl.create :comment_flag, comment: @comment, :user => another_user
        delete :destroy, { user_id: @user.id, comment_id: @comment.id, id: @comment_flag.id }
      end

      it { should respond_with 401 }
    end



  end


end
