require "./spec_helper"
require "../src/adapter/pg"

class User < Kemalyst::Model
  adapter pg
  sql_mapping({ 
    name: ["VARCHAR(255)", String],
    pass: ["TEXT", String]
  })
end

User.drop
User.create

describe Kemalyst::Adapter::Pg do
  Spec.before_each do
    User.clear
  end

  describe "#all" do
    it "finds all the users" do
      user = User.new
      user.name = "Test User"
      user.save
      user = User.new
      user.name = "Test User 2"
      user.save
      users = User.all
      users.size.should eq 2
    end
  end

  describe "#find" do
    it "finds the user by id" do
      user = User.new
      user.name = "Test User"
      user.save
      id = user.id
      user = User.find id
      user.should_not be_nil 
    end
  end

  describe "#save" do
    it "creates a new user" do
      user = User.new
      user.name = "Test User"
      user.pass = "Password"
      user.save
      user.id.should_not be_nil 
    end

    it "updates an existing user" do
      user = User.new
      user.name = "Test User"
      user.save
      user.name = "Test User 2"
      user.save
      user = User.find 1
      if user
        user.name.should eq "Test User 2"
      end
    end
  end

  describe "#destroy" do
    it "destroys a user" do
      user = User.new
      user.name = "Test User"
      user.save
      id = user.id
      user.destroy
      user = User.find id
      user.should be_nil
    end
  end

end

