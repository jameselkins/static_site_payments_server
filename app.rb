require 'sinatra'
require 'dotenv/load'
require 'stripe'
require 'money'

if development?
  require "sinatra/reloader"
  require "pry"
end
# black magic from rubymoney see
# https://github.com/RubyMoney/money#troubleshooting
I18n.enforce_available_locales = false

set :stripe_publishable_key, ENV['STRIPE_PUBLISHABLE_KEY']
set :stripe_secret_key, ENV['STRIPE_SECRET_KEY']
set :page_after_purchase, ENV['PAGE_AFTER_PURCHASE']
# TODO: throw error here if product_list is invalid
set :product_list, JSON.parse(ENV['PRODUCT_LIST_KEYED_BY_AMOUNT_DESC_KEY'])
set :customer_list_page_size, 100

# TODO: check for valid api key
Stripe.api_key = settings.stripe_secret_key

if development? || test?
  get '/' do
    haml :index
  end

  get '/success' do
    haml :success
  end
end

post '/' do
  # index the product list by product key
  product_list_by_key = settings.product_list.map do |product|
    [product['product_key'], product]
  end.to_h

  # TODO: throw error here if product_key is invalid
  product = product_list_by_key[params['product_key']]

  customers = {}
  # TODO: wrap in error handler
  # TODO:
  Stripe::Customer.list(limit: settings.customer_list_page_size).auto_paging_each do |customer|
    customers[customer.email] = customer.id
  end

  # TODO: wrap in error handler
  customer_id = customers[params[:stripeEmail]] ||
      Stripe::Customer.create(email: params[:stripeEmail], source: params[:stripeToken]).id

  Stripe::Charge.create(
    amount: product['amount'],
    description: "#{product['product_key']}: #{product['description']}",
    currency: 'usd',
    customer: customer_id
  )

  redirect to(settings.page_after_purchase)
end
