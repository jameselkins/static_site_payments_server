this is a sinatra server that lets you accept payments on your static website quickly and easily.  It will also associate multiple charges from one customer to that same customer.

# How to use
1. Deploy it to heroku with your stripe api keys, purchase page, and product list using this button:
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

2. Make a form on your own website

# Local Development
Make sure you have an up-to-date version of ruby installed. Then:

1. `git clone git@github.com/jameselkins/static_site_payments_server`
2. `cd static_site_payments_server`
3. `bundle install`
4. `bundle exec ruby app.rb`
5. `echo -e STRIPE_PUBLISHABLE_KEY=YOUR_KEY\\nSTRIPE_SECRET_KEY=YOUR_SECRET_KEY\\nPAGE_AFTER_PURCHASE='/success'\\nPRODUCT_LIST_KEYED_BY_AMOUNT_DESC_KEY=[{"product_key": "test_product", "amount": 500, "description": "this is a test product"},{"product_key": "test_product_2", "amount": 600, "description": "this is a second test product"}] > .env`

6. `open http://localhost:4567`

# Testing
Run `bundle exec rake spec` while inside the repo.