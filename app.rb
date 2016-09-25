#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'

set :database, 'sqlite3:barbershop.db'

class Client < ActiveRecord::Base
  validates :name, presence: {message: "Введите имя!"}, length: {minimum: 3}
  validates :phoneno, presence: true
  validates :datestamp, presence: true
  validates :barber, presence: true
  validates :color, presence: true
end

class Barber < ActiveRecord::Base

end

class Contact < ActiveRecord::Base

end

configure do
end

get '/' do
  @barbers = Barber.all
	erb :index
end

before '/visit' do
   @barbers = Barber.all
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

get '/bookings' do
	@clients = Client.order('created_at DESC')
	erb :bookings
end

get '/bookings/:id' do
	@client = Client.find(params[:id])
	erb :client
end

get '/barbers/:id' do
	@barber = Barber.find(params[:id])
	erb :barber
end

post '/contacts' do
  if params[:contact][:email].empty? then
    @error = "Не указан почтовый адрес для связи!"
    return erb :contacts
  elsif !params[:contact][:message] then
    @error = "Напишите текст обращения!"
    return erb :contacts
  else    
    new_c = Contact.new(params[:contact])
    # new_c.email = params[:email] 
    # new_c.message = params[:msg]
    new_c.save
    erb "Сообщение сохранено!"
  end
end

post '/visit' do

  #validation
  # hh = {  :username => 'Введите ваше имя',
  #         :phoneno => 'Введите телефон',
  #         :plantime => 'Введите дату и время' }
 
  # @error = hh.select {|key,_| params[:client][key] == ""}.values.join(", ")
 
  # if @error != ''
  #   return erb :visit
  # end

  # input = File.open('.\public\visit.txt', 'a+')
  # input.write("#{params[:username]}; #{params[:plantime]}; #{params[:phoneno]}; #{params[:barber]}\n")
  # input.close
  # get_db().execute('INSERT INTO 
  #               users 
  #                 (name,
  #                 phone,
  #                 datestamp,
  #                 barber,
  #                 color)
  #               values (?, ?, ?, ?, ?)', [params[:username], params[:phoneno], params[:plantime], params[:barber], params[:color]]);
  # Client.create(name: params[:username], phoneno: params[:phoneno], datestamp: params[:plantime], barber: params[:barber], color: params[:color])
  c = Client.new(params[:client])

  if !c.save then #!c.valid? then
    @error = c.errors.full_messages.first
    return erb :visit
  end

  erb "Уважаемый #{params[:client][:name]}, данные записаны! Ждем вас в #{params[:client][:datestamp]}"

end