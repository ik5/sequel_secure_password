require 'spec_helper'

describe "model using Sequel::Plugins::SecurePassword" do
  subject(:user) { User.new }

  context "with blank password" do
    before { user.password = "" }

    it { should_not be_valid }
  end

  context "with nil password" do
    before { user.password = nil }

    it { should_not be_valid }
  end

  context "without setting a password" do
    it { should_not be_valid }
  end

  context "without confirmation" do
    before { user.password = "foo" }

    it { should_not be_valid }
  end

  context "having cost within password_digest" do
    before { user.password = "foo" }
    it {
      BCrypt::Password.new(user.password_digest).cost.should be BCrypt::Engine::DEFAULT_COST
    }
  end

  context "when password matches confirmation" do
    before { user.password = user.password_confirmation = "foo" }

    it { should be_valid }
  end

  describe "#authenticate" do
    let(:secret) { "foo" }
    before { user.password = secret }

    context "when authentication is successful" do
      it "returns the user" do
        user.authenticate(secret).should be user
      end
    end

    context "when authentication fails" do
      it { user.authenticate("").should be nil }
    end
  end

  describe "with cost option" do
    subject(:highcost_user) { HighCostUser.new }
    context "having cost within password_digest" do
      before { highcost_user.password = "foo" }
      it {
        BCrypt::Password.new(highcost_user.password_digest).cost.should be 12
      }
    end

  end
end
