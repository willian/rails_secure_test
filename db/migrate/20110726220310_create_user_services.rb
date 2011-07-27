class CreateUserServices < ActiveRecord::Migration
  def change
    create_table :user_services do |t|
      t.references :user
      t.string :name
      t.string :uid
      t.string :uname
      t.string :uemail

      t.timestamps
    end
    add_index :user_services, :user_id
  end
end
