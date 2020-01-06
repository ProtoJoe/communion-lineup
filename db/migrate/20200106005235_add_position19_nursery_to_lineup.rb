class AddPosition19NurseryToLineup < ActiveRecord::Migration[6.0]
  def change
    add_column :lineups, :position_19, :string
  end
end
