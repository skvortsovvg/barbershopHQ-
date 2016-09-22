class BarbersTable < ActiveRecord::Migration
  def change
  	create_table :barbers do |t|
  		t.text 	:name
   		t.timestamps
  	end

  	Barber.create :name => 'Jessie Pinkman'
  	Barber.create :name => 'Walter While'
  	Barber.create :name => 'Gus Fring'
  	Barber.create :name => 'Edvard'
  end
end
