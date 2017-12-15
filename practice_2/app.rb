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

#메인페이지
get '/' do
  @posts = Post.all
  erb :index
end
#1.Create 글 작성
get '/new' do
  erb :new
end

get '/create' do
  @post = Post.create(title: params[:title], content: params[:content])
  redirect '/'
end

#2.Read 글 호출, 검색
get '/posts' do
  @ID = params[:title]
  @searchID = Post.get(:title => @ID)
  erb :posts
end

get '/post/:id' do
  @id = params[:id]
  @post = Post.get(id: @id)
  erb :post
end

#3.Update
get '/edit/:id' do
  @post = Post.get(params[:id])
  erb :edit
end

get '/update/:id' do
  @post = Post.get(params[:id])
  @post.update(title: params[:title], content: params[:content])
  redirect '/'
end

#4.Destroy
get '/destroy/:id' do
  @post = Post.get(params[:id])
  @post.destroy
  redirect '/'
end
