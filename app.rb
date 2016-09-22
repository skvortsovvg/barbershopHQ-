#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'

set :database, 'sqlite3:barbershop.db'

class Client < ActiveRecord::Base

end

class Barber < ActiveRecord::Base

end

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger mutherfucker!'
  end
end

get '/' do
  @barbers = Barber.all()
	erb :index
end

before '/visit' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/login/form' do
  @error = ""
  erb :login_form
end

get '/logout' do
  session.delete(:identity)
  session.delete(:pwd)
  erb "<div class='alert alert-message'>Logged out</div>"
end

post '/login/attempt' do
  if params['userpassword'] == 'secret' then
  	session[:identity] = params['username']
	session[:pwd] = params['userpassword']
  	erb :visit
  else
    @error = "Invalid password!"
    erb :login_form
  end

end

post '/visit' do
	input = File.open('.\public\visit.txt', 'a+')
	input.write("#{params[:username]}; #{params[:plantime]}; #{params[:phoneno]}; #{params[:barber]}\n")
	input.close
	erb "Уважаемый #{params[:username]}, данные записаны! Ждем вас в #{params[:plantime]}"
end

post '/contacts' do
	input = File.open('.\public\contacts.txt', 'a+')
	input.write("#{params[:email]}; #{params[:msg]}\r")
	input.close
	erb "Данные отправлены, спасибо за обращение!"
end