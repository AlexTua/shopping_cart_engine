class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, &:timestamps
  end
end
