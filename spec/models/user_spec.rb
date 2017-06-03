require 'spec_helper'

describe User do
  it "should require a username" do
    User.new(:name => "").should_not be_valid
  end

end
