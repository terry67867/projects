require 'sinatra'
require 'sinatra/reloader'
#가상환경에서 쓰이는 것
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
#DB table 제작
class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :content, Text
  property :created_at, DateTime
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :email, String
  property :pwd, Text
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize
# automatically create the post table
Post.auto_upgrade!
User.auto_upgrade!

set :bind, '0.0.0.0' #가상머신에서 실행한 것을 Windows에서 확인하기위해 선언

before do
  p '*************************************'
  p params
  p '*************************************'
end

get '/' do
  @posts = Post.all.reverse
  erb :index
end

get '/post' do
  erb :post
end

get '/complete' do
  #Post.create(:title => params[:title], :content => params[:content])
  @title = params[:title]
  @content = params[:content]
  Post.create(:title => @title, :content => @content)
  #Post.create(title: @title, content: @content)
  erb :complete
end

get '/signup' do
  erb :signup
end

get '/usercomplete' do
  @email = params[:email]
  @pwd = params[:pwd]
  User.create(:email => @email, :pwd => @pwd)
  erb :usercomplete
end

get '/users' do
  @users = User.all
  erb :users
end

#gem install data_mapper
#gem install dm-sqlite-adapter

#Model (DB) -SQL
#C-R-U-D
#C:create ex)게시글 하나를 쓴다.
#R:Read ex)게시판 목록/ 하나의 게시글
#U:Update ex)게시글 수정
#D:Destroy ex)게시글 삭제
