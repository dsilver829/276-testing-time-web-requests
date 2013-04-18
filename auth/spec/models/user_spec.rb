require 'spec_helper'
require 'timecop'

describe User do
  describe "#send_password_reset" do
    let(:user) { FactoryGirl.create(:user) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      Timecop.freeze
      user.send_password_reset
      Time.use_zone("Paris") do
        user.reload.password_reset_sent_at.to_i.should == Time.zone.now.to_i
      end
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end
end
