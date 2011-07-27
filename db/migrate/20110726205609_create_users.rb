class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :permalink, :null => false
      t.string :email, :null => false
      t.string :password_digest, :null => false
      t.string :avatar
      t.string :gender
      t.string :phone
      t.string :cellphone
      t.string :cpf
      t.datetime :birthday

      t.timestamps
    end
  end
end
