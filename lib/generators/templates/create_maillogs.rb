class CreateMaillogs < (ActiveRecord::Migration.respond_to?(:[]) ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration)
  def change
    create_table :maillogs do |t|
      t.text :message, null: false
      t.string :bcc
      t.string :state, null: false, index: true
      t.string :exception_class_name
      t.text :exception_message

      t.timestamps null: false
    end
  end
end
