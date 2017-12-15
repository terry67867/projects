require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'

set :bind, '0.0.0.0'
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
class Post
  include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :content, Text
    property :created_at, DateTime
end
DataMapper.finalize
Post.auto_upgrade!

get '/' do
  @post = Post.all
  erb :index
end

get '/new' do
  erb :new
end

#Create
get '/create' do
  @title=params[:title]
  @content=params[:content]
  Post.create(title: @title, content: @content)
  redirect '/'
end

#Read
get '/post/:id' do
  @id = params[:id]
  Post.get(id: @id)
  erb :post
end
#Update - edit
get '/edit/:id' do
  @post = Post.get(params[:id])
  erb :edit
end
#Update - update
get '/update/:id' do
  @post=Post.get(params[:id])
  @post.update(title: params[:title],content: params[:content])
  redirect '/'
end
#Destroy
get '/destroy/:id' do
  Post.get(params[:id]).destroy
  redirect '/'
end
