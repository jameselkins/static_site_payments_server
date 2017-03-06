require_relative 'spec_helper.rb'

describe "payments server" do
  describe "when going to the front page" do
    it "works" do
      get '/'
      last_response.ok?
    end
  end


  describe "when submitting a charge to the endpoint", vcr: { match_requests_on: [:method, :host] } do
    describe "when using an email that belongs to a customer" do
      it "works" do
        post '/', stripeEmail: 'george@malarky.com', stripeToken: 'tok_19uIeb2fM1xslBXYILTDCoBL', product_key: 'test_product'
        last_response.ok?
      end
    end

    describe "when using a new email" do
      it "works" do
        post '/', stripeEmail: 'george@new_new_guy.com', stripeToken: 'tok_19uIdj2fM1xslBXYjJEiCVpu', product_key: 'test_product'
        last_response.ok?
      end
    end

  end
end