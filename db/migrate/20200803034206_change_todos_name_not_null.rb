class ChangeTodosNameNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :todos, :name, false
  end
end
