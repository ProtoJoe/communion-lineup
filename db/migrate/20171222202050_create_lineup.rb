class CreateLineup < ActiveRecord::Migration[5.0]
  def change
    create_table :lineups do |t|
      t.date    :service_date
      t.string  :position_1
      t.string  :position_2
      t.string  :position_3
      t.string  :position_4
      t.string  :position_5
      t.string  :position_6
      t.string  :position_7
      t.string  :position_8
      t.string  :position_9
      t.string  :position_10
      t.string  :position_11
      t.string  :position_12
      t.string  :position_13
      t.string  :position_14
      t.string  :position_15
      t.string  :position_16
      t.string  :position_17
      t.string  :position_18

      t.timestamps
    end
  end
end
