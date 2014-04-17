require 'spec_helper'

describe Topic do
  let!(:topic1) { Factory.create(:topic)}
  it  "have title" do
    puts topic1
  end
end
