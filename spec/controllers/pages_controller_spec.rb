require 'spec_helper'

describe PagesController do


  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'product'" do
    it "should be successful" do
      get 'product'
      response.should be_success
    end
  end

  describe "GET 'services'" do
    it "should be successful" do
      get 'services'
      response.should be_success
    end
  end

  describe "GET 'company'" do
    it "should be successful" do
      get 'company'
      response.should be_success
    end
  end
end
