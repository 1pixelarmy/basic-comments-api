require 'spec_helper'

RSpec.describe CommentFlag, type: :model do
  let(:comment_flag) { FactoryGirl.build :comment_flag }
  subject { comment_flag }

  it { should respond_to(:comment_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:inappropriate) }

  it { should validate_presence_of :comment_id }
  it { should validate_presence_of :user_id }

  it { should belong_to :comment }
  it { should belong_to :user }
end
