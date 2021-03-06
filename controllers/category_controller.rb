require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/category.rb')

get '/categories' do
  @categories = Category.all()

  erb (:"category/index")
end

get '/categories/totals' do
  @categories = Category.all()
  erb(:"category/totals/index")
end

get '/categories/totals_may' do
  @categories = Category.all()
  erb(:"category/totals_may/index")
end

get '/categories/totals_june' do
  @categories = Category.all()
  erb(:"category/totals_june/index")
end

get '/categories/new' do
  @categories = Category.all()
  erb (:"category/new")
end

post '/categories' do
  Category.new(params).save
  redirect to '/categories'
end

get '/categories/:id/edit' do # edit
  @category = Category.find( params[:id] )
  erb( :"category/edit" )
end

post '/categories/:id' do
  Category.new(params).update
  redirect to '/categories'
end
